--  Feedback Comb Filter
--
--  Description: This is a simple feedback comb filter with variable gain and delay.
--
--  Revision History:
--      Steven Okai     07/26/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use work.GeneralFuncPkg.all;

entity FeedbackCombFilter is
    generic (
        MAX_DELAY   : positive;
        WIDTH       : positive
        -- TODO: Add generic to force DSP?
        -- TODO: Add generic for gain width?
    );
    port (
        Clk     : std_logic;
        
        Delay           : in  std_logic_vector(log2(MAX_DELAY)-1 downto 0);
        Gain            : in  std_logic_vector(WIDTH-1 downto 0);
        
        DataIn          : in  std_logic_vector(WIDTH-1 downto 0);
        DataInValid     : in  std_logic;
        
        DataOut         : out std_logic_vector(WIDTH-1 downto 0);
        DataOutValid    : out std_logic
    );

end FeedbackCombFilter;

architecture rtl of FeedbackCombFilter is

    signal DataP0               : std_logic_vector(WIDTH-1 downto 0);
    signal DataP1               : std_logic_vector(WIDTH-1 downto 0);
    signal DataValidP           : std_logic_vector(0 to 1);
    
    signal DataSumP0            : std_logic_vector(WIDTH-1 downto 0):
    signal DataDelayAttenutated : std_logic_vector(WIDTH-1 downto 0);
    
    begin
    
    -- TODO: ASSERT THAT MAX DELAY IS POWER OF 2???
    -- TODO: add optional LPF in feedback path?
    
    DataP0 <= DataIn;
    DataValidP(0) <= DataInValid;
    
    DataOut <= DataP1;
    DataOutValid <= DataValidP(1);
    
    delay_line : entity work.DynamicBRAMDelayLine
        generic map (
            MAX_DEPTH   => MAX_DELAY,   --: positive;   -TODO: is there an advantage to this being -1?
            WIDTH       => WIDTH        --: positive
        );
        port (
            Clk         => Clk,             --: in  std_logic;
            Enable      => DataValidP(0),   --: in  std_logic;
            
            -- TODO: Should this be delay - 1?
            Delay       => Delay,           --: in  std_logic_vector(log2(MAX_DEPTH)-1 downto 0);
            DataIn      => DataSumP0,       --: in  std_logic_vector(WIDTH-1 downto 0);
            DataOut     => DataDelayOut     --: out std_logic_vector(WIDTH-1 downto 0)
        );
        
    DataSumP0  <= std_logic_vector(signed(DataP0) + signed(DataDelayAttenutated));
    
    process (Clk)
        begin
        if (rising_edge(Clk)) then
            DataValidP(1) <= DataValidP(0);
            
            if (DataValidP(0) = '1') then
                DataDelayAttenutated <= trunc_right(std_logic_vector(signed(DataDelayOut) * signed('0' & Gain)), DataDelayAttenutated'length);
                DataP1 <= DataSumP0;
            end if;
        end if;
    end process;
    
end rtl;
