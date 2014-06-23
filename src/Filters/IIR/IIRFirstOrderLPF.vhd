--  IIR First Order Low-Pass Filter
--
--  Description: General IIR first order low-pass filter.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     06/22/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.GeneralFuncPkg.all;

entity IIRFirstOrderLPF is
    generic (
        DATA_WIDTH      : positive
    );
    port (
        Clk             : in  std_logic;
        Reset           : in  std_logic;
        
        Enable          : in  std_logic;
        
        SmoothingFactor : in  std_logic_vector(DATA_WIDTH-2 downto 0);
        
        DataIn          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        DataInValid     : in  std_logic;
        
        DataOut         : out std_logic_vector(DATA_WIDTH-1 downto 0);
        DataOutValid    : out std_logic
    );
end IIRFirstOrderLPF;

architecture rtl of IIRFirstOrderLPF is

    constant ONE    : std_logic_vector(SmoothingFactor'length downto 0) := pad_right("0", SmoothingFactor'length+1, '1');
    
    signal DataP0       : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal DataP1       : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal DataP2       : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    signal DataValidP   : std_logic_vector(0 to 2);
    
    signal SmoothingFactorInt           : std_logic_vector(SmoothingFactor'length downto 0);
    signal OneMinusSmoothingFactorInt   : std_logic_vector(SmoothingFactor'length downto 0);
    
    
    begin
    
    DataValidP(0) <= DataInValid;
    DataP0 <= DataIn;
    
    DataOutValid <= DataValidP(2);
    DataOut <= DataP2;
    
    process (Clk)
        begin
        if (rising_edge(Clk)) then
            SmoothingFactorInt <= '0' & SmoothingFactor;
            OneMinusSmoothingFactorInt <= std_logic_vector(signed(ONE) - signed(('0' & SmoothingFactor)));
        end if;
    end process;
    
    process (Clk, Reset)
        variable TempDataP1 : std_logic_vector((DataP0'length+SmoothingFactorInt'length)-1 downto 0);
        variable TempDataP2 : std_logic_vector((DataP0'length+OneMinusSmoothingFactorInt'length)-1 downto 0);
        begin
        
        if (rising_edge(Clk)) then
        
            DataValidP(DataValidP'low+1 to DataValidP'high) <= DataValidP(DataValidP'low to DataValidP'high-1);
            
            if (Enable = '1') then
                -- P1
                TempDataP1 := std_logic_vector(signed(DataP0) * signed(SmoothingFactorInt));
                DataP1 <= TempDataP1(DataP0'length+SmoothingFactorInt'length-2 downto SmoothingFactorInt'length-1);
                
                -- P2
                if (DataValidP(1) = '1') then
                    TempDataP2 := std_logic_vector(signed(OneMinusSmoothingFactorInt) * signed(DataP2));
                    DataP2 <= std_logic_vector(signed(DataP1) + signed(TempDataP2(DataP1'length+SmoothingFactorInt'length-2 downto OneMinusSmoothingFactorInt'length-1)));
                end if;
            else
                DataP1 <= DataP0;
                DataP2 <= DataP1;
            end if;
            
        end if;
        
        if (Reset = '1') then
            DataP2 <= (others=>'0');
        end if;
    
    end process;
    
end rtl;
