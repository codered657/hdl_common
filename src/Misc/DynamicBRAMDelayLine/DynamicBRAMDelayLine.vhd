--  Dynamic Block RAM Delay Line
--
--  Description: A general dynamic block RAM delay line.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     06/28/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.GeneralFuncPkg.all;

entity DynamicBRAMDelayLine is
    generic (
        MAX_DEPTH   : positive;
        WIDTH       : positive
    );
    port (
        Clk     : in  std_logic;
        Enable  : in  std_logic;
        
        Delay   : in  std_logic_vector(log2(MAX_DEPTH)-1 downto 0);
        DataIn  : in  std_logic_vector(WIDTH-1 downto 0);
        DataOut : out std_logic_vector(WIDTH-1 downto 0)
    );
    
end DynamicBRAMDelayLine;

architecture rtl of DynamicBRAMDelayLine is

    signal AddressWr    : std_logic_vector(log2(MAX_DEPTH)-1 downto 0);
    signal AddressRd    : std_logic_vector(log2(MAX_DEPTH)-1 downto 0);
    
    begin
    
    process (Clk)
        begin
        if (rising_edge(Clk)) then
            -- Shift on enable only.
            if (Enable = '1') then
                AddressWr <= AddressWr + 1; -- Increment write pointer.
                AddressRd <= AddressWr - Delay - 1;
            end if;
        end if;
    end process;
    
    block_ram : entity work.BlockRAM
        generic map (
            DEPTH   => MAX_DEPTH,           --: positive;
            WIDTH   => WIDTH                --: positive
        )
        port map (
            ClkA        => Clk,             --: in  std_logic;
            AddressA    => AddressWr,       --: in  std_logic_vector(log2(DEPTH)-1 downto 0);
            WriteEnA    => Enable,          --: in  std_logic;
            DataInA     => DataIn,          --: in  std_logic_vector(WIDTH-1 downto 0);
            DataOutA    => open,            --: out std_logic_vector(WIDTH-1 downto 0);
            
            ClkB        => Clk,             --: in  std_logic;
            AddressB    => AddressRd,       --: in  std_logic_vector(log2(DEPTH)-1 downto 0);
            WriteEnB    => '0',             --: in  std_logic;
            DataInB     => (others=>'0'),   --: in  std_logic_vector(WIDTH-1 downto 0);
            DataOutB    => DataOut          --: out std_logic_vector(WIDTH-1 downto 0)
        );
        
end rtl;
