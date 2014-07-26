--  Distributed RAM
--
--  Description: This is a simple Xilinx distributed RAM.
--
--  Notes: http://www.xilinx.com/support/documentation/white_papers/wp231.pdf
--         http://vhdlguru.blogspot.com/2011/01/block-and-distributed-rams-on-xilinx.html
--
--  Revision History:
--      Steven Okai     03/18/14    1) Initial revision.
--      Steven Okai     07/26/14    1) Updated for dual port.
--                                  2) Added option for registered outputs.
--

library ieee;
use ieee.std_logic_1164.all;

use work.GeneralFuncPkg.all;

entity DistRAM is
    generic (
        DEPTH       : positive;
        WIDTH       : positive;
        REG_OUT_A   : boolean := FALSE;
        REG_OUT_B   : boolean := FALSE
    );
    port (
        Clk         : in  std_logic;
        
        AddressA    : in  std_logic_vector(log2(Depth)-1 downto 0);
        WriteEnA    : in  std_logic;
        DataInA     : in  std_logic_vector(WIDTH-1 downto 0);
        DataOutA    : out std_logic_vector(WIDTH-1 downto 0);
        
        AddressB    : in  std_logic_vector(log2(Depth)-1 downto 0);
        DataInB     : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity DistRAM;

architecture rtl of DistRAM is

    type memory is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);
    
    signal ram : memory;
    attribute ram_style : string;
    attribute ram_style of ram : signal is "distributed";   -- Ensure distributed RAM is used in synthesis.
    
    signal DataOutAInt  : std_logic_vector(WIDTH-1 downto 0);
    signal DataOutAReg  : std_logic_vector(WIDTH-1 downto 0);
    signal DataOutBInt  : std_logic_vector(WIDTH-1 downto 0);
    signal DataOutBReg  : std_logic_vector(WIDTH-1 downto 0);
    
    begin
    
    process (Clk)
        begin
        if (rising_edge(Clk)) then
        
            -- If write enable set, update value in RAM.
            if (WriteEnA = '1') then
                ram(slv_to_unsigned_int(AddressA)) <= DataInA;
            end if;
        
            DataOutAReg <= DataOutAInt;
            DataOutBReg <= DataOutBInt;
        end if;
    end process;
    
    -- Get read data asynchronously.
    DataOutAInt <= ram(slv_to_unsigned_int(AddressA));
    DataOutBInt <= ram(slv_to_unsigned_int(AddressB));
    
    -- Generate output registers if necessary.
    gen_output_reg_a : if (REG_OUT_A) generate
        DataOutA <= DataOutAReg;
    end generate gen_output_reg_a;
    
    gen_no_output_reg_a : if (not REG_OUT_A) generate
        DataOutA <= DataOutAInt;
    end generate gen_no_output_reg_a;
    
    gen_output_reg_b : if (REG_OUT_B) generate
        DataOutB <= DataOutBReg;
    end generate gen_output_reg_b;
    
    gen_no_output_reg_b : if (not REG_OUT_B) generate
        DataOutB <= DataOutBInt;
    end generate gen_no_output_reg_b;
    
end architecture rtl;