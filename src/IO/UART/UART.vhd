--  Universal Asynchronous Transmitter and Receiver 
--
--  Description: Configurable UART, with FIFO interface to FPGA.
--
--  Notes: None.
--
--  Limitations:
--      1) Only odd integer number of stop bits supported.
--      2) Only odd parity supported.
--
--  Revision History:
--      Steven Okai     07/26/14    1) Initial revision.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.GeneralFuncPkg.all;

entity UART is
    generic (
        CLK_FREQ            : real := 25000000.0;
        BAUD_RATE           : real := 9600.0;
        BAUD_ACCUM_WIDTH    : positive := 16;
        WIDE_MODE           : boolean := TRUE;
        NUM_STOP_BITS       : positive := 1
    );
    port (
        Clk             : in  std_logic;
        Reset           : in  std_logic;
        
        RxIn            : in  std_logic;
        TxOut           : out std_logic;
        
        RxDataOut       : out std_logic_vector(7 downto 0);
        RxOverrunError  : out std_logic; 
        RxFramingError  : out std_logic; 
        RxBreak         : out std_logic;
        RxParityError   : out std_logic;
        RxFIFOPush      : out std_logic;
        
        TxDataIn        : in  std_logic_vector(7 downto 0);
        TxFIFOEmpty     : in  std_logic;
        TxFIFOPop       : out std_logic
    );
end UART;

architecture rtl of UART is

    function get_num_payload_bits (WIDE_MODE : boolean) return positive is
        variable B  : positive;
        begin
        if (WIDE_MODE) then
            B := 16;
        else
            B := 8;
        end if;
        return B;
    end get_num_payload_bits;
    
    type rx_fsm_state is (RX_IDLE, RX_BITS);
    type tx_fsm_state is (TX_IDLE, TX_BITS);
    
    constant BAUD_INCR  : integer := integer((BAUD_RATE*8.0 * 2.0**BAUD_ACCUM_WIDTH)/CLK_FREQ);
    
    constant NUM_PAYLOAD_BITS   : positive := get_num_payload_bits(WIDE_MODE);
    constant NUM_TOTAL_BITS     : positive := 1 + NUM_PAYLOAD_BITS + NUM_STOP_BITS; -- Start bit + payload + stop bits.
    
    -- TODO: should this be BAUD_ACCUM_WIDTH downto 0?
    signal BaudAccum    : std_logic_vector(BAUD_ACCUM_WIDTH downto 0);
    
    signal RxSync       : std_logic;
    signal RxNextBit        : std_logic;
    signal RxFIFOPushInt    : std_logic;
    signal RxDataInt        : std_logic_vector(NUM_TOTAL_BITS-1 downto 0);
    signal RxState          : rx_fsm_state;
    signal RxBitCount       : std_logic_vector(log2(NUM_TOTAL_BITS+1) downto 0);
    signal RxBitSpacingCount    : std_logic_vector(2 downto 0);
    
    signal TxDataInt        : std_logic_vector(NUM_TOTAL_BITS-1 downto 0);
    signal TxNextBit        : std_logic;
    signal TxFIFOPopInt     : std_logic;
    signal TxFIFODataValid  : std_logic;
    signal TxState          : tx_fsm_state;
    signal TxBitCount       : std_logic_vector(log2(NUM_TOTAL_BITS+1) downto 0);
    signal TxBitSpacingCount    : std_logic_vector(2 downto 0);
    
    alias BaudTick  : std_logic is BaudAccum(BaudAccum'high);

    begin
    
    process (Clk, Reset)
    
        begin
        
        if (rising_edge(Clk)) then
            BaudAccum <= ('0' & BaudAccum(BaudAccum'high-1 downto 0)) + BAUD_INCR;
        end if;
        if (Reset = '1') then
            BaudAccum <= (others=>'0');
        end if;
    end process;
    
    rx_resync : entity work.Resynchronizer
        generic map (
            LENGTH  => 2       --: positive := 2
        )
        port map (
            Clk     => Clk,     --: in  std_logic;
            Reset   => '0',     --: in  std_logic;
            
            LineIn  => RxIn,    --: in  std_logic;
            LineOut => RxSync   --: out std_logic
        );
    
    -- 
    RxNextBit <= bool_to_sl(RxBitSpacingCount = "111"); -- TODO: magic number?
    
    rx_fsm : process (Clk, Reset)
        begin
        
        if (rising_edge(Clk)) then
            RxFIFOPush <= '0';   -- Rx data not valid by default.
            if (BaudTick = '1') then
                case (RxState) is
                    when RX_IDLE =>
                        if (RxSync = '0') then
                            RxState <= RX_BITS; -- Start bit detected, start shifting in bits.
                        end if;
                        RxBitCount <= (others=>'0');        -- Clear bit count.
                        RxBitSpacingCount <= (others=>'0'); -- Start counter for spacing bits.
                        RxBitSpacingCount(0) <= '1'; -- Start counter for spacing bits.
                    when RX_BITS => 
                        if (RxNextBit = '1') then
                            RxBitCount <= RxBitCount + 1;
                            RxDataInt <= RxDataInt(RxDataInt'high-1 downto 0) & RxSync; -- Shift in next bit.
                            if (RxBitCount = unsigned_int_to_slv(NUM_TOTAL_BITS, RxBitCount'length)) then
                                RxState <= RX_IDLE;
                                RxFIFOPush <= '1';   -- Pulse data out valid.

                                if (WIDE_MODE) then
                                    -- Add NUM_STOP_BITS to bit index since bit 0 is stop bit.
                                    RxDataOut <= reverse(RxDataInt(15+NUM_STOP_BITS downto 8+NUM_STOP_BITS));
                                    RxOverrunError <= RxDataInt(3+NUM_STOP_BITS);
                                    RxFramingError <= RxDataInt(2+NUM_STOP_BITS);
                                    RxBreak <= RxDataInt(1+NUM_STOP_BITS);
                                    RxParityError <= RxDataInt(0+NUM_STOP_BITS);
                                else
                                    RxDataOut <= reverse(RxDataInt(7+NUM_STOP_BITS downto 0+NUM_STOP_BITS));
                                    RxOverrunError <= '0';
                                    RxFramingError <= '0';
                                    RxBreak <= '0';
                                    RxParityError <= '0';
                                end if;
                            end if;
                        end if;
                        RxBitSpacingCount <= RxBitSpacingCount + 1; -- Increment bit spacing counter.
                end case;
            end if;
            
        end if;
        
        if (Reset = '1') then
            RxState <= RX_IDLE;
        end if;
        
    end process rx_fsm;
    
    TxOut <= TxDataInt(TxDataInt'high); -- This should be one wider than number of bits.
    
    TxNextBit <= bool_to_sl(TxBitSpacingCount = "111"); -- TODO: magic number?
    
    TxFIFOPop <= TxFIFOPopInt;
    
    tx_fsm : process (Clk, Reset)
        variable TxDataIntTemp  : std_logic_vector(NUM_TOTAL_BITS-NUM_STOP_BITS-1 downto 0);
        begin
        if (rising_edge(Clk)) then
            TxFIFODataValid <= TxFIFOPopInt;
            if (TxFIFODataValid = '1') then
                -- Append start bit to front and stop bits to end.
                if (WIDE_MODE) then
                    TxDataIntTemp := '0' & reverse(TxDataIn) & "0000000" & xor_reduce(TxDataIn);
                    TxDataInt <= append_right(TxDataIntTemp, NUM_STOP_BITS, '1'); -- Latch Tx Data and start bit.
                else
                    TxDataIntTemp := '0' & reverse(TxDataIn);
                    --TxDataInt <= '0' & TxDataIn & xor_reduce(TxDataIn);  -- Latch Tx Data and start bit.
                    TxDataInt <= append_right(TxDataIntTemp, NUM_STOP_BITS, '1'); -- Latch Tx Data and start bit.
                end if;
            end if;
             
            TxFIFOPopInt <= '0';   -- Do not pop FIFO by default.
            if (BaudTick = '1') then
                case (TxState) is
                    when TX_IDLE =>
                        if (TxFIFOEmpty = '0') then
                            TxFIFOPopInt <= '1';   -- TODO: need to decide when exactly this pop occurs.
                            TxState <= TX_BITS;
                        end if;
                        TxBitCount <= (others=>'0');        -- Start bit count.
                        TxBitSpacingCount <= (others=>'0'); -- Start bit spacing count.
                    when TX_BITS =>
                        if (TxNextBit = '1') then
                            TxBitCount <= TxBitCount + 1;
                            TxDataInt <= TxDataInt(TxDataInt'high-1 downto 0) & '1';
                            if (TxBitCount = unsigned_int_to_slv(NUM_TOTAL_BITS, TxBitCount'length)) then
                                TxState <= TX_IDLE;
                            end if;
                        end if;
                        TxBitSpacingCount <= TxBitSpacingCount + 1;
                end case;
            end if;
        end if;
        
        if (Reset = '1') then
            TxState <= TX_IDLE;
            TxDataInt <= (others=>'1');
        end if;
    end process tx_fsm;
    
end rtl;
