--  Resynchronizer
--
--  Description: This module synchronizes a signal across clock domains.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     07/26/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;

entity Resynchronizer is
    generic (
        LENGTH  : positive := 2
    );
    port (
        Clk     : in  std_logic;
        Reset   : in  std_logic;
        
        LineIn  : in  std_logic;
        LineOut : out std_logic
    );
end Resynchronizer;

architecture rtl of Resynchronizer is

    signal LineP    : std_logic_vector(0 to LENGTH);
    -- TODO: add syn_preserve on registers so they do not become SRLs.
    begin
    
    LineP(LineP'low) <= LineIn;
    LineOut <= LineP(LineP'high);
    
    process (Clk, Reset)
        begin
        if (rising_edge(Clk)) then
            LineP(LineP'low+1 to LineP'high) <= LineP(LineP'low to LineP'high-1);
        end if;
        if (Reset = '1') then
            LineP(LineP'low+1 to LineP'high) <= (others=>'0');
        end if;
    end process;
end rtl;
