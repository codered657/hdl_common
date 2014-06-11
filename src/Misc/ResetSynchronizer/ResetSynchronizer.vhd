--  Reset Synchronizer
--
--  Description: This modules takes and asynchronous reset and outputs a reset which is
--               asserted asynchronously and released synchronously.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     03/17/14    1) Initial revision.
--      Steven Okai     06/10/14    1) Fixed compile errors.
--

library ieee;
use ieee.std_logic_1164.all;

entity ResetSynchronizer is
    generic (
        NUM_STAGES  :  natural range 2 to 8 := 2    -- Number of synchronization stages.
    );
    port (
        Clk      : in  std_logic;
        ResetIn  : in  std_logic;
        ResetOut : out std_logic
    );
end entity ResetSynchronizer;

architecture RTL of ResetSynchronizer is

    -- Synchronization registers
    signal SyncStages : std_logic_vector(0 to NUM_STAGES-1);
    
    begin
    
    process (Clk, ResetIn)
        begin
        -- Assert reset asynchronously.
        if (ResetIn = '1') then
            SyncStages <= (others => '1');
            
        -- Release reset synchronously.
        elsif (rising_edge(Clk)) then
            SyncStages <= '0' & SyncStages(0 to SyncStages'high-1);
            
        end if;
    end process;
    
    -- Output of last synchronization register is synchronized reset.
    ResetOut <= SyncStages(SyncStages'high);
   
end architecture RTL;