--  Block RAM
--
--  Description: This is a simple Xilinx block RAM.
--
--  Notes: http://www.xilinx.com/support/documentation/white_papers/wp231.pdf
--         http://vhdlguru.blogspot.com/2011/01/block-and-distributed-rams-on-xilinx.html
--         http://danstrother.com/2010/09/11/inferring-rams-in-fpgas/
--
--  Revision History:
--      Steven Okai     03/18/14    1) Initial revision.
--      Steven Okai     07/26/14    1) Changed to true dual-port RAM.
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
        ClkA        : in  std_logic;
        AddressA    : in  std_logic_vector(log2(DEPTH)-1 downto 0);
        WriteEnA    : in  std_logic;
        DataInA     : in  std_logic_vector(WIDTH-1 downto 0);
        DataOutA    : out std_logic_vector(WIDTH-1 downto 0);
        
        ClkB        : in  std_logic;
        AddressB    : in  std_logic_vector(log2(DEPTH)-1 downto 0);
        WriteEnB    : in  std_logic;
        DataInB     : in  std_logic_vector(WIDTH-1 downto 0);
        DataOutB    : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity BlockRAM;
    
architecture rtl of BlockRAM is

    type memory is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
    
    shared variable ram : memory;
    attribute ram_style : string;
    attribute ram_style of ram : variable is "block"; -- Ensure block RAM is used in synthesis.
    
    begin
    
    port_a : process (ClkA)
        begin
        if (rising_edge(ClkA)) then
            -- If write enable set, update value in RAM.
            if (WriteEnA = '1') then
                ram(slv_to_unsigned_int(AddressA)) := DataInA;
            end if;
            DataOutA <= ram(slv_to_unsigned_int(AddressA)); -- Read out value on port A.
        end if;
    end process port_a;
    
    port_b : process (ClkB)
        begin
        if (rising_edge(ClkB)) then
            -- If write enable set, update value in RAM.
            if (WriteEnB = '1') then
                ram(slv_to_unsigned_int(AddressB)) := DataInB;
            end if;
            DataOutB <= ram(slv_to_unsigned_int(AddressB)); -- Read out value on port B.
        end if;
    end process port_b;
    
end architecture rtl;