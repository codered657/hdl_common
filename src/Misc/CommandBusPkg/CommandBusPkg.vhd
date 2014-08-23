--  Command Bus Package
--
--  Description: This package contains definitions for command bus.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     07/31/14    1) Initial revision.
--      Steven Okai     08/23/14    1) Removed dependence on slv arguments being downto.
--

library ieee;
use ieee.std_logic_1164.all;
use work.GeneralFuncPkg.all;

package CommandBusPkg is

    type cmd_bus_in is
        record
            Address     : std_logic_vector(63 downto 0);
            Write       : std_logic;
            Read        : std_logic;
            Data        : std_logic_vector(255 downto 0);
        end record;
        
    type cmd_bus_in_vector is array (natural range <>) of cmd_bus_in;
        
    type cmd_bus_out is
        record
            Ack         : std_logic;
            Data        : std_logic_vector(255 downto 0);
        end record;
        
    type cmd_bus_out_vector is array (natural range <>) of cmd_bus_out;
    
    constant CMD_BUS_IN_IDLE    : cmd_bus_in := ((others=>'0'), '0', '0', (others=>'0'));
    
    procedure cmd_bus_write (
               Address      : in  std_logic_vector; -- TODO: should this be not typed?
               Data         : in  std_logic_vector; -- TODO: should this be not typed?
        signal Clk          : in  std_logic;
        signal CmdBusIn     : out cmd_bus_in;
        signal CmdBusOut    : in  cmd_bus_out
    );
    
    procedure cmd_bus_read (
               Address      : in  std_logic_vector; -- TODO: should this be not typed?
               Data         : out std_logic_vector; -- TODO: should this be not typed?
        signal Clk          : in  std_logic;
        signal CmdBusIn     : out cmd_bus_in;
        signal CmdBusOut    : in  cmd_bus_out
    );
    
    procedure cmd_bus_write_verify (
               Address      : in  std_logic_vector;
               Data         : in  std_logic_vector;
        signal Clk          : in  std_logic;
        signal CmdBusIn     : out cmd_bus_in;
        signal CmdBusOut    : in  cmd_bus_out
    );
      
end package;

package body CommandBusPkg is
    
    procedure cmd_bus_write (
               Address      : in  std_logic_vector; -- TODO: should this be not typed?
               Data         : in  std_logic_vector; -- TODO: should this be not typed?
        signal Clk          : in  std_logic;
        signal CmdBusIn     : out cmd_bus_in;
        signal CmdBusOut    : in  cmd_bus_out
        ) is
        
        begin
        
        wait until rising_edge(Clk);
        CmdBusIn.Address <= pad_left(Address, CmdBusIn.Address'length, '0');
        CmdBusIn.Data <= pad_left(Data, CmdBusIn.Data'length, '0');
        CmdBusIn.Write <= '1';

        while (CmdBusOut.Ack /= '1') loop
            wait until rising_edge(Clk);
        end loop;
        
        -- TODO: should we wait on more clock before deasserting?
        CmdBusIn <= CMD_BUS_IN_IDLE;
        wait until rising_edge(Clk);
        
    end cmd_bus_write;
    
    procedure cmd_bus_read (
               Address      : in  std_logic_vector; -- TODO: should this be not typed?
               Data         : out std_logic_vector; -- TODO: should this be not typed?
        signal Clk          : in  std_logic;
        signal CmdBusIn     : out cmd_bus_in;
        signal CmdBusOut    : in  cmd_bus_out
        ) is
        
        begin
        
        wait until rising_edge(Clk);
        CmdBusIn.Address <= pad_left(Address, CmdBusIn.Address'length, '0');
        CmdBusIn.Read <= '1';

        while (CmdBusOut.Ack /= '1') loop
            wait until rising_edge(Clk);
        end loop;

        Data := CmdBusOut.Data(Data'length-1 downto 0); -- Immediately latch data.

        -- TODO: should we wait on more clock before deasserting?
        CmdBusIn <= CMD_BUS_IN_IDLE;
        wait until rising_edge(Clk);
        
    end cmd_bus_read;
    
    procedure cmd_bus_write_verify (
               Address      : in  std_logic_vector;
               Data         : in  std_logic_vector;
        signal Clk          : in  std_logic;
        signal CmdBusIn     : out cmd_bus_in;
        signal CmdBusOut    : in  cmd_bus_out
        ) is
        variable WriteData  : std_logic_vector(Data'length-1 downto 0);
        variable ReadData   : std_logic_vector(Data'length-1 downto 0);
        begin
        WriteData := Data;
        cmd_bus_write(Address, WriteData, Clk, CmdBusIn, CmdBusOut);
        cmd_bus_read(Address, ReadData, Clk, CmdBusIn, CmdBusOut);

        assert (ReadData = WriteData) report "Read data does not match written data." severity FAILURE;
    end cmd_bus_write_verify;
    
end CommandBusPkg;
