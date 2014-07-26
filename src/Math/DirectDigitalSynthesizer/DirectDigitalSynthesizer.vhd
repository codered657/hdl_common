--  Direct Digital Synthesizer
--
--  Description: Generates waveforms with dynamic period.
--
--  Notes: None.
--
--  Limitations:
--      1) Only sine wave supported.
--
--  Revision History:
--      Steven Okai     07/26/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.GeneralFuncPkg.all;
use work.TrigPkg.all;

entity DirectDigitalSynthesizer is
    generic (
        PERIOD_SIZE     : positive := 4096;
        TABLE_SIZE      : positive := 1024;
        OUTPUT_WIDTH    : positive := 32
    );
    port (
        Clk             : in  std_logic;
        Reset           : in  std_logic;
        Enable          : in  std_logic;
        
        FreqScaling     : in  std_logic_vector(log2(PERIOD_SIZE/(TABLE_SIZE*2))-1 downto 0);
        
        WaveOut         : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
        WaveOutValid    : out std_logic
        
    );
end DirectDigitalSynthesizer;

architecture rtl of DirectDigitalSynthesizer is
    
    signal PeriodCount      : std_logic_vector(log2(PERIOD_SIZE)-1 downto 0);
    signal NextPeriodCount  : std_logic_vector(log2(PERIOD_SIZE)-1 downto 0);

    signal WaveOutValidP    : std_logic_vector(0 to 4);
    
    signal PeriodCountP1    : std_logic_vector(log2(PERIOD_SIZE)-1 downto 0);
    signal PeriodCountP2    : std_logic_vector(log2(PERIOD_SIZE)-1 downto 0);
    
    signal CurrentSineP1    : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    signal CurrentSineP2    : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    signal CurrentSineP3    : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    
    signal NextSineP1       : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    
    signal SineDifferenceP2 : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    signal SineDeltaP3      : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    
    signal SineP4           : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    
    constant NUM_PHASE_BITS : natural := log2(PERIOD_SIZE/(TABLE_SIZE*2));
    
    constant NUM_TABLE_REDUCE_BITS  : natural :=  log2(TABLE_SIZE/1024);
    
    begin
    
    assert (TABLE_SIZE <= 1024) report "TABLE_SIZE too large. Must be <= 1024." severity FAILURE;
    assert (OUTPUT_WIDTH <= 32) report "OUTPUT_WIDTH too large. Must be <= 32." severity FAILURE;
    assert (NUM_PHASE_BITS >= 0) report "NUM_PHASE_BITS too small. Must be >= 0." severity FAILURE;  -- TOOD: remove this limitation.
    
    WaveOutValidP(0) <= Enable;
    
    process (Clk)
        variable CurrentSineIndex   : natural;
        variable NextSineIndex      : natural;
        begin
        
        if (rising_edge(Clk)) then
        
            WaveOutValidP(WaveOutValidP'low+1 to WaveOutValidP'high) <= WaveOutValidP(WaveOutValidP'low to WaveOutValidP'high-1);
            
            if (Enable = '1') then
                NextPeriodCount <= pad_right((PeriodCount(PeriodCount'high downto NUM_PHASE_BITS) + 1), NextPeriodCount'length, '0');
                PeriodCount <= PeriodCount + FreqScaling;
                PeriodCountP1 <= PeriodCount;
                PeriodCountP2 <= PeriodCountP1;
            end if;
            
            -- Multiply table count increment by 2**NUM_TABLE_REDUCE_BITS so entries are skipped reducing table size.
            CurrentSineIndex := slv_to_unsigned_int(append_right(PeriodCount(PeriodCount'high-1 downto NUM_PHASE_BITS), NUM_TABLE_REDUCE_BITS, '0'));
            NextSineIndex := slv_to_unsigned_int(append_right(NextPeriodCount(NextPeriodCount'high-1 downto NUM_PHASE_BITS), NUM_TABLE_REDUCE_BITS, '0'));
            
            if (PeriodCount(PeriodCount'high) = '0') then
                CurrentSineP1 <= trunc_right(SINE_2048(CurrentSineIndex), CurrentSineP1'length);
            else
                CurrentSineP1 <= negate(trunc_right(SINE_2048(CurrentSineIndex), CurrentSineP1'length));
            end if;
            if (NextPeriodCount(NextPeriodCount'high) = '0') then
                NextSineP1 <= trunc_right(SINE_2048(NextSineIndex), NextSineP1'length);
            else
                NextSineP1 <= negate(trunc_right(SINE_2048(NextSineIndex), NextSineP1'length));
            end if;
            
            CurrentSineP2 <= CurrentSineP1;
            CurrentSineP3 <= CurrentSineP2;
        end if;
    end process;
    
    gen_linear_interpolation : if (NUM_PHASE_BITS > 0) generate
        process (Clk)
            variable TempSineDelta :    std_logic_vector(OUTPUT_WIDTH+NUM_PHASE_BITS-1 downto 0);
            begin
            if (rising_edge(Clk)) then

                SineDifferenceP2 <= NextSineP1 - CurrentSineP1;
                
                TempSineDelta := SineDifferenceP2 * PeriodCountP2(NUM_PHASE_BITS-1 downto 0);
                SineDeltaP3 <= TempSineDelta(NUM_PHASE_BITS+OUTPUT_WIDTH-1 downto NUM_PHASE_BITS);
                
                SineP4 <= SineDeltaP3 + CurrentSineP3;
                
            end if;
            
        end process;
        
        WaveOut <= SineP4;
        WaveOutValid <= WaveOutValidP(4);
        
    end generate gen_linear_interpolation;
    
    gen_no_linear_interpolation : if (NUM_PHASE_BITS <= 0) generate
        WaveOut <= CurrentSineP1;
        WaveOutValid <= WaveOutValidP(1);
    end generate gen_no_linear_interpolation;
    
end rtl;
