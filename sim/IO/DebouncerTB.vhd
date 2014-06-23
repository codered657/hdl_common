--  Push Button Debouncer Test Bench
--
--  Description: Test bench for single push button debouncer.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     06/22/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;

entity DebouncerTB is
    generic (
        TestID  : natural := 0
    );
end DebouncerTB;

architecture test of DebouncerTB is
    
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic := '1';

    signal KeyIn    : std_logic := '0';
    signal KeyOut   : std_logic;

    signal Press    : std_logic;
    signal Release  : std_logic;

    begin
    
    Clk <= not Clk after 5 ns;
    
    process
        begin
        
        wait for 50 ns;
        Reset <= '0';
        
        wait until rising_edge(Clk);
        KeyIn <= '1';
        
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        KeyIn <= '0';
        
        wait until rising_edge(Clk);
        KeyIn <= '1';
        
        wait until KeyOut = '1';
        KeyIn <= '0';
        
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
        KeyIn <= '1';
        
        wait until rising_edge(Clk);
        KeyIn <= '0';
        
        wait until KeyOut = '0';
        
        wait;
    end process;
    
    uut : entity work.Debouncer
        generic map (
            COUNTER_WIDTH   => 4        --: positive := 4
        )
        port map (
            Clk             => Clk,     --: in  std_logic;
            Reset           => Reset,   --: in  std_logic;
            
            KeyIn           => KeyIn,   --: in  std_logic;
            KeyOut          => KeyOut,  --: out std_logic;
            
            Press           => Press,   --: out std_logic;
            Release         => Release  --: out std_logic 
        );
end test;