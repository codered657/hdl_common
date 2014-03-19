--  Block RAM
--
--  Description: This is a simple Xilinx block RAM.
--
--  Notes: http://www.xilinx.com/support/documentation/white_papers/wp231.pdf
--         http://vhdlguru.blogspot.com/2011/01/block-and-distributed-rams-on-xilinx.html
--
--  Revision History:
--      Steven Okai     03/18/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;

use work.GeneralFuncPkg.all;

entity BlockRAM is
    generic (
        DEPTH   : positive;
        WIDTH   : positive
    );
    port (
        Clk     : in  std_logic;
        Address : in  std_logic_vector(log2(Depth)-1 downto 0);
        WriteEn : in  std_logic;
        
        DataIn  : in  std_logic_vector(WIDTH-1 downto 0);
        DataOut : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity BlockRAM;

    type memory is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
    
    signal ram : memory;
    attribute ram_style : string;
    attribute ram_style of ram : signal is "block"; -- Ensure block RAM is used in synthesis.
    
architecture RTL of BlockRAM is

    begin
    
    process (Clk)
    
        begin
        
        if (rising_edge(Clk)) then
        
            -- If write enable set, update value in RAM.
            if (WriteEn = '1') then
                ram(slv_to_unsigned_int(Address)) <= DataIn;
            -- Otherwise, read out value.
            else
                DataOut <= ram(slv_to_unsigned_int(Address));
            end if;
        
        end if;
        
end architecture RTL;