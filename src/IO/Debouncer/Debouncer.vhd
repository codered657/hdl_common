--  Push Button Debouncer
--
--  Description: A single push button debouncer.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     06/22/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.GeneralFuncPkg.all;

entity Debouncer is
    generic (
        COUNTER_WIDTH   : positive := 4
    );
    port (
        Clk         : in  std_logic;
        Reset       : in  std_logic;
        
        KeyIn       : in  std_logic;
        KeyOut      : out std_logic;
        
        Press       : out std_logic;
        Release     : out std_logic 
    );
end Debouncer;

architecture rtl of Debouncer is

    signal KeyP     : std_logic_vector(0 to 3);
    signal Counter  : std_logic_vector(COUNTER_WIDTH-1 downto 0);
    
    begin
    
    KeyP(0) <= KeyIn;
    KeyOut <= KeyP(3);
    
    process (Clk, Reset)
        variable TempCounter    : std_logic_vector(COUNTER_WIDTH downto 0);
        begin
        if (rising_edge(Clk)) then
            
            -- Key pipeline.
            KeyP(1 to 2) <= KeyP(0 to 1);
            
            -- No press or release registered by default.
            Press <= '0';
            Release <= '0';
            
            -- On an edge, start counting again.
            if (KeyP(1) /= KeyP(2)) then
                Counter <= (others => '0');
            else
                TempCounter := increment('0' & Counter);
                
                -- On a counter overflow, latch press.
                if (TempCounter(TempCounter'high) = '1') then
                    KeyP(3) <= KeyP(2);
                    Press <= (not KeyP(3)) and KeyP(2);     -- Detect press (rising edge) and release (falling edge).
                    Release <= KeyP(3) and (not KeyP(2));
                    
                end if;
                
                Counter <= TempCounter(Counter'range);
                
            end if;
            
        end if;
        if (Reset = '1') then
            Counter <= (others=>'0');
            KeyP(3) <= '0';
        end if;
    end process;
end rtl;
    