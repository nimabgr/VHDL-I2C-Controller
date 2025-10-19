library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity I2C is
    PORT (
            clk              : in    STD_LOGIC;
            O_SCL            : out   STD_LOGIC := '1';
            IO_SDA           : inout STD_LOGIC := '1';
            I_Slave_Add      : in    STD_LOGIC_VECTOR(7 downto 0);
            I_Reg_Add        : in    STD_LOGIC_VECTOR(7 downto 0);
            I_Data_1         : in    STD_LOGIC_VECTOR(8 downto 0);
            I_Data_2         : in    STD_LOGIC_VECTOR(8 downto 0);
            I_Data_3         : in    STD_LOGIC_VECTOR(8 downto 0);
            Master_EN        : in    STD_LOGIC;
            O_Data           : out   STD_LOGIC_VECTOR(7 downto 0) := (others => '0') ;
            I_Slave_Memory   : in    STD_LOGIC_VECTOR(7 downto 0)
        );
end I2C;

architecture Behavioral of I2C is
Type Condition is (Start , Stop , Read , Write );
signal ST : Condition ;  -- States 
signal State             : Natural range 0 to 500 := 0 ; -- steps
signal S_Slave_Add       : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal S_Reg_Add         : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal S_Data_1          : STD_LOGIC_VECTOR(8 downto 0):= (others => '0'); --for multy input
signal S_Data_2          : STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal S_Data_3          : STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal RW                : STD_LOGIC;
begin
    process(clk)
    begin
        if (rising_edge(clk))then
            case State is
                when 0 =>
                    if Master_EN = '0' then 
                        O_Data <= "00000000";
                        O_SCL  <= '1';
                        IO_SDA <= '1';
                        State  <= 0 ;
                    elsif Master_EN = '1' then
                        S_Slave_Add <= I_Slave_Add ;
                        S_Reg_Add <= I_Reg_Add ;
                        S_Data_1 <= I_Data_1 ;
                        S_Data_2 <= I_Data_2 ;
                        S_Data_3 <= I_Data_3 ;
                        State <= State + 1 ;
                   end if ;
------------------------------------------------------------ Start condition
                
                when 1 =>
                    St <= Start;
                    
                    IO_SDA <= '0';
                    State <= State + 1 ;
                when 2 => 
                    O_SCL <= '0';
                    State <= State + 1 ;
                    
------------------------------------------------------------ Slave Address (part)

                when 3 =>
                    IO_SDA <= S_Slave_Add(7);
                    State <= State + 1 ;
                when 4 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                     
                when 5 =>
                    O_SCL <= '0';
                    State <= State + 1 ;
                    
                when 6 =>
                    IO_SDA <= S_Slave_Add(6);
                    State <= State + 1 ;
                    
                when 7 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 8 =>
                    O_SCL <= '0';
                    State <= State + 1 ;
                when 9 =>
                    IO_SDA <= S_Slave_Add(5);
                    State <= State + 1 ;
                    
                when 10 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 11 =>
                    O_SCL <= '0';
                    State <= State + 1 ;
                when 12 =>
                    IO_SDA <= S_Slave_Add(4);
                    State <= State + 1 ;
                when 13 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                    
                when 14 =>
                    O_SCL <= '0';
                    State <= State + 1 ;
                when 15 =>
                    IO_SDA <= S_Slave_Add(3);
                    State <= State + 1 ;
                    
                when 16 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 17 =>
                    O_SCL <= '0';
                    State <= State + 1 ;
                when 18 =>
                    IO_SDA <= S_Slave_Add(2);
                    State <= State + 1 ;
                when 19 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 20 =>
                    O_SCL <= '0';
                    State <= State + 1 ;
                when 21 =>
                    IO_SDA <= S_Slave_Add(1);
                    State <= State + 1 ;
                when 22 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 23 =>
                    O_SCL <= '0';
                    State <= State + 1 ;  
                when 24 => --(define RW bit)
                    IO_SDA <= S_Slave_Add(0);
                    if S_Slave_Add(0) = '1' then
                        RW <= '1';
                        State <= State + 1 ;
                    elsif S_Slave_Add(0) = '0' then
                        RW <= '0';
                        State <= State + 1 ;
                    end if ;
                when 25 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 26 => 
                    O_SCL <= '0'; 
                    --IO_SDA <= 'Z';
                    State <= State + 1 ;
                when 27 =>
                    IO_SDA <= '0';
                    if IO_SDA = '0' then --ACK
                        State <= 350 ;
                    elsif IO_SDA = '1' then --NAK
                        if S_Slave_Add /= I_Slave_Add then --curept 
                            State <= 0;
                        elsif S_Slave_Add = I_Slave_Add then --slave is busy
                            State <= 26;
                        end if ;
                    end if ;
                when 350 =>
                    O_SCL <= '1';
                    State <= 351 ;
                when 351 =>
                    O_SCL <= '0' ;
                    State <= 28;
                    
------------------------------------------------------------ Reg Address

                when 28 =>
                    IO_SDA <= S_Reg_Add(7);
                    State <= State + 1 ;
                when 29 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 30 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 31 =>
                    IO_SDA <= S_Reg_Add(6);
                    State <= State + 1 ;
                when 32 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 33 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 34 =>
                    IO_SDA <= S_Reg_Add(5);
                    State <= State + 1 ;
                when 35 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 36 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 37 =>
                    IO_SDA <= S_Reg_Add(4);
                    State <= State + 1 ;
                when 38 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 39 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 40 =>
                    IO_SDA <= S_Reg_Add(3);
                    State <= State + 1 ;
                when 41 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 42 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 43 =>
                    IO_SDA <= S_Reg_Add(2);
                    State <= State + 1 ;
                when 44 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 45 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 46 =>
                    IO_SDA <= S_Reg_Add(1);
                    State <= State + 1 ;
                when 47 =>
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 48 =>
                    O_SCL <= '0';
                    State <= State + 1;
                when 49 =>
                    IO_SDA <= S_Reg_Add(0);
                    State <= State + 1 ;
                when 50 =>
                    O_SCL <= '1' ;
                    State <= State + 1 ;
                when 51 =>
                    O_SCL <= '0' ;
                    --IO_SDA <= 'Z';
                    State <= State + 1 ;
                when 52 =>
                    IO_SDA <= '0';
                    if IO_SDA = '0' then --ACK
                        State <= 53 ;
                    --elsif IO_SDA = '1' then --NAK (Reg Address currept)
                        --State <= x ;
                    end if;
                when 53 =>
                       O_SCL <= '1';
                       State <= 200 ;
                when 200 =>
                       O_SCL <= '0';
                       State <= 201 ;
                --when 53 =>
                       --if RW = '1' then 
                            --State <= 54 ;
                       --elsif RW = '0' then
                            --State <= 81 ;
                       --end if;
                       
------------------------------------------------------------------------- Data (Part)
--------------------------------------------------------------(R) (Read Data from Slave and show in O_Data)
                when 201 =>
                    if RW = '1' then 
                        ST <= Read ;
                        O_SCL <= '1';
                        State <= 54;
                    elsif RW = '0' then
                        State <= 81 ;
                    end if ;
                when 54 =>
                    IO_SDA <= I_Slave_Memory(7);
                    O_Data(7) <= Io_SDA;
                    State <= State + 1 ;
                when 55 => 
                    O_SCL <= '0';
                    State <= State + 1 ;
                when 56 =>
                        O_SCL <= '1';
                        State <= State + 1;
                when 57 =>
                    IO_SDA <= I_Slave_Memory(6);
                        O_Data(6) <= Io_SDA;
                    State <= State + 1 ;
                when 58 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                when 59 =>
                        O_SCL <= '1' ;
                        State <= State + 1;
                when 60 =>
                    IO_SDA <= I_Slave_Memory(5);
                        O_Data(5) <= Io_SDA;
                    State <= State + 1 ;
                when 61 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                when 62 =>
                        O_SCL <= '1' ;
                        State <= State + 1;
                when 63 =>
                    IO_SDA <= I_Slave_Memory(4);
                        O_Data(4) <= Io_SDA;
                    State <= State + 1 ;
                when 64 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                when 65 =>
                        O_SCL <= '1';
                        State <= State + 1;
                when 66 =>
                    IO_SDA <= I_Slave_Memory(3);
                        O_Data(3) <= Io_SDA;
                    State <= State + 1 ;
                when 67 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                when 68 =>
                        O_SCL <= '1' ;
                        State <= State + 1;
                when 69 =>
                    IO_SDA <= I_Slave_Memory(2);
                        O_Data(2) <= Io_SDA;
                    State <= State + 1 ;
                when 70 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                when 71 =>
                        O_SCL <= '1';
                        State <= State + 1;
                when 72 =>
                    IO_SDA <= I_Slave_Memory(1);
                        O_Data(1) <= Io_SDA;
                    State <= State + 1 ;
                when 73 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                when 74 =>
                        O_SCL <= '1' ;
                        State <= State + 1;
                when 75 =>
                    IO_SDA <= I_Slave_Memory(0);
                        O_Data(0) <= Io_SDA;
                        O_Data <= I_slave_Memory;
                    State <= State + 1 ;
                when 76 =>
                    O_SCL <= '0';
                    State <= state + 1 ;
                
                when 77 => --Ack Master to Slave 
                       IO_SDA <= '0';
                       State <= State + 1 ;
                when 78 =>
                       O_SCL <= '1';
                       State <= State + 1 ;
                when 79 =>
                       O_SCL <= '0';
                       State <= 106 ;
                       
--------------------------------------------------------------(W) Write data (put data from master to SDA)
                                
                when 81 =>
                      ST <= Write ;
                      IO_SDA <= S_Data_1(8);
                      State <= State + 1 ;
                when 82 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 83 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 84 =>
                      IO_SDA <= S_Data_1(7);
                      State <= State + 1 ;
                when 85 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 86 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 87 =>
                      IO_SDA <= S_Data_1(6);
                      State <= State + 1 ;
                when 88 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 89 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 90 =>
                      IO_SDA <= S_Data_1(5);
                      State <= State + 1 ;
                when 91 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 92 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 93 =>
                      IO_SDA <= S_Data_1(4);
                      State <= State + 1 ;
                when 94 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 95 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 96 =>
                      IO_SDA <= S_Data_1(3);
                      State <= State + 1 ;
                when 97 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 98 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 99 =>
                      IO_SDA <= S_Data_1(2);
                      State <= State + 1 ;
                when 100 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 101 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 102 =>
                      IO_SDA <= S_Data_1(1);
                      State <= State + 1 ;
                when 103 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 104 =>
                      O_SCL <= '0';
                      --IO_SDA <= 'Z';
                      State <= State + 1 ;
                when 105 => --(ACK Slave to Master)
                      IO_SDA <= '0';
                      if IO_SDA = '0' then
                           State <= 450 ;
                      --elsif IO_SDA = '1' then --(currepted data)
                           --State <= state + 1;
                      end if;
                when 450 =>
                       O_SCL <= '1';
                       State <= 451 ;
                when 451 =>
                       O_SCL <= '0';
----------------------------------------------------- check for continue Data
                if S_Data_1(0) = '0' then 
                    State <= 106 ;
                elsif S_Data_1(0) = '1' then 
                    State <= 452 ;
                end if;
                
                when 452 =>
                      ST <= Write ;
                      IO_SDA <= S_Data_2(8);
                      State <= State + 1 ;
                when 453 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 454 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 455 =>
                      IO_SDA <= S_Data_2(7);
                      State <= State + 1 ;
                when 456 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 457 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 458 =>
                      IO_SDA <= S_Data_2(6);
                      State <= State + 1 ;
                when 459 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 460 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 461 =>
                      IO_SDA <= S_Data_2(5);
                      State <= State + 1 ;
                when 462 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 463 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 464 =>
                      IO_SDA <= S_Data_2(4);
                      State <= State + 1 ;
                when 465 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 466 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 467 =>
                      IO_SDA <= S_Data_2(3);
                      State <= State + 1 ;
                when 468 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 469 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 470 =>
                      IO_SDA <= S_Data_2(2);
                      State <= State + 1 ;
                when 471 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 472 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 473 =>
                      IO_SDA <= S_Data_2(1);
                      State <= State + 1 ;
                when 474 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 475 =>
                      O_SCL <= '0';
                      --IO_SDA <= 'Z';
                      State <= 476 ;
                when 476 => --(ACK Slave to Master)
                      IO_SDA <= '0';
                      if IO_SDA = '0' then
                           State <= 477 ;
                      --elsif IO_SDA = '1' then --(currepted data)
                           --State <= state + 1;
                      end if;
                when 477 =>
                       O_SCL <= '1';
                       State <= 451 ;
                when 478 =>
                       O_SCL <= '0';
----------------------------------------------------- check for continue Data
                       if S_Data_2(0) = '0' then 
                            State <= 106 ;
                       elsif ST = Write and S_Data_2(0) = '1' then 
                            State <= 479 ;
                       end if;
                
                when 479 =>
                      ST <= Write ;
                      IO_SDA <= S_Data_3(8);
                      State <= State + 1 ;
                when 480 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 481 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 482 =>
                      IO_SDA <= S_Data_3(7);
                      State <= State + 1 ;
                when 483 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 484 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 485 =>
                      IO_SDA <= S_Data_3(6);
                      State <= State + 1 ;
                when 486 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 487 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 488 =>
                      IO_SDA <= S_Data_3(5);
                      State <= State + 1 ;
                when 489 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 490 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 491 =>
                      IO_SDA <= S_Data_3(4);
                      State <= State + 1 ;
                when 492 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 493 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 494 =>
                      IO_SDA <= S_Data_3(3);
                      State <= State + 1 ;
                when 495 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 496 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 497 =>
                      IO_SDA <= S_Data_3(2);
                      State <= State + 1 ;
                when 498 =>
                      O_SCL <= '1';
                      State <= State + 1 ;
                when 499 =>
                      O_SCL <= '0';
                      State <= State + 1 ;
                when 500 =>
                      IO_SDA <= S_Data_3(1);
                      State <= 360 ;
                when 360 =>
                      O_SCL <= '1';
                      State <= 361 ;
                when 361 =>
                      O_SCL <= '0';
                      --IO_SDA <= 'Z';
                      State <= 362 ;
                when 362 => --(ACK Slave to Master)
                      IO_SDA <= '0';
                      if IO_SDA = '0' then
                           State <= 363 ;
                      --elsif IO_SDA = '1' then --(currepted data)
                           --State <= 363;
                      end if;
                when 363 =>
                       O_SCL <= '1';
                       State <= 364 ;
                when 364 =>
                       O_SCL <= '0';
----------------------------------------------------- check for continue Data
                       if S_Data_3(0) = '0' then 
                            State <= 106 ;
                       --elsif ST = Write and S_Data_3(0) = '1' then   
                            --State <= x ;
                       end if;
                       
                              
------------------------------------------------------------ stop condition     
   
                when 106 =>
                    ST <= Stop;
                    O_SCL <= '1';
                    State <= State + 1 ;
                when 107 =>
                    IO_SDA <= '1';
                when others =>
                    Report "Erorr";   
            end case;        
        end if;         
    end process;                
       
end Behavioral;
