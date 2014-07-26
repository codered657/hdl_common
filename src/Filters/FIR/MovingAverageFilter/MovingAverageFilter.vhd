--  Moving Average Filter
--
--  Description: Simple moving average filter using no multipliers/dividers.
--
--  Notes: WINDOW_SIZE must be a power of 2.
--
--  Revision History:
--      Steven Okai     07/26/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.GeneralFuncPkg.all;

entity MovingAverageFilter is
    generic (
        WIDTH       : positive;
        WINDOW_SIZE : positive
    );
    port (
        Clk             : in  std_logic;
        
        DataIn          : in  std_logic_vector(WIDTH-1 downto 0);
        DataInValid     : in  std_logic;
        
        DataOut         : out std_logic_vector(WIDTH-1 downto 0);
        DataOutValid    : out std_logic
    );
end MovingAverageFilter;

architecture rtl of MovingAverageFilter is

    type data_pipe is array (natural range <>) of std_logic_vector(WIDTH-1 downto 0);
    
    type adder_stage is array (natural range <>) of std_logic_vector(WIDTH+log2(WINDOW_SIZE)-1 downto 0);
    type adder_tree is array (natural range <>) of adder_pipe(0 to WINDOW_SIZE-1);
    
    signal SumP : adder_tree(0 to log2(WINDOW_SIZE));
    
    signal DataP        : data_pipe(0 to log2(WINDOW_SIZE));
    signal DataValidP   : std_logic_vector(0 to log2(WINDOW_SIZE));
    begin
    
    assert (2**log2(WINDOW_SIZE) = WINDOW_SIZE) report "WINDOW_SIZE must be a pwoer of 2." severity FAILURE;
    
    DataP(0) <= DataIn;
    DataValidP <= DataInValid;
    
    DataOut <= trunc_right(SumP(SumP'high)(0), DataOut'length); -- Shift right to div by WINDOW_SIZE;
    DataOutValid <= DataValidP(DataValidP'high);
    
    gen_delay_map : for i in 0 to WINDOW_SIZE-1 generate
        SumP(0)(i) <= sign_extend(DataP(i), SumP(0)(i)'length);
    end generate gen_delay_map;
        
    process (Clk)
        variable delay_i    : natural;
        begin
        
        if (rising_edge(Clk)) then
        
            DataValidP(DataValidP'low+1 to DataValidP'high) <= DataValidP(DataValidP'low to DataValidP'high-1);

            if (DataValidP(0) = '1') then
                DataP(DataP'low+1 to DataP'high) <= DataP(DataP'low to DataP'high-1);
            end if;
            
            -- Pipelined adder tree.
            for i in log2(WINDOW_SIZE/2)-1 downto 0 loop
                delay_i := i - (log2(WINDOW_SIZE/2)-1); -- Number of inputs to pipeline stage is opposite of pipeline index.
                for j in 0 to 2**i - 1 loop
                    SumP(delay_i+1)(j) <= SumP(delay_i)(2*j) + SumP(delay_i)(2*j + 1);
                end loop;
            end loop;
        end if;
    end process;
end rtl;
