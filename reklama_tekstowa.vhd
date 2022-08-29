LIBRARY ieee;  
USE ieee.std_logic_1164.all; 
 
ENTITY reklama_tekstowa IS
  -- zedfiniowanie wejść i wyjść dla całej architektury 
  PORT ( SW      : IN      STD_LOGIC_VECTOR(17 DOWNTO 0);
  HEX0  : OUT      STD_LOGIC_VECTOR(0 TO 6);
	
  -- dodanie pozostałych portów wyjściowych => kolejne wyświetlacze 7 segmentowe
  HEX1 : OUT STD_LOGIC_VECTOR(0 TO 6);
  HEX2 : OUT STD_LOGIC_VECTOR(0 TO 6);
  HEX3 : OUT STD_LOGIC_VECTOR(0 TO 6); 
  HEX4 : OUT STD_LOGIC_VECTOR(0 TO 6); 
  HEX5 : OUT STD_LOGIC_VECTOR(0 TO 6); 
  HEX6 : OUT STD_LOGIC_VECTOR(0 TO 6); 
  HEX7 : OUT STD_LOGIC_VECTOR(0 TO 6)); 
END reklama_tekstowa;


ARCHITECTURE  strukturalna OF reklama_tekstowa IS
  CONSTANT  SPACJA: STD_LOGIC_VECTOR(2 DOWNTO 0):= "000";  -- KOD SPACJI – uwaga na rodzaj ”” przy kompilacji 
    
  --DEKLARACJA KOMPONENTÓW => muliptekser, określenie wejść i wyjść
  COMPONENT mux3bit8to1 
    PORT ( S, U0, U1, U2, U3, U4, U5,U6,U7: IN     STD_LOGIC_VECTOR(2 DOWNTO 0);  --WEKTOR STERUJĄCY I 8 wektorów INFORMACYJNYCH               
    M                  : OUT    STD_LOGIC_VECTOR(2 DOWNTO 0));
  END COMPONENT;     
  
  --DEKLARACJA KOMPONENTÓW => transkoder
  COMPONENT char7seg       
    PORT ( C           : IN      STD_LOGIC_VECTOR(2 DOWNTO 0);                
    Display    : OUT     STD_LOGIC_VECTOR(0 TO 6));
  END COMPONENT;     
  
  -- dodanie kolejnych sygnałów => wyjścia z multipleksera/wejścia do ukłądu transkodera na 7bin
  SIGNAL M0 : STD_LOGIC_VECTOR(2 DOWNTO 0);  
  SIGNAL M1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL M2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL M3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL M4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL M5 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL M6 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL M7 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  
-- KONKRETYZACJA UŻYCIA KOMPONENTÓW  
BEGIN 
-- KONKRETYZACJE KOLEJNYCH MULTIPLEKSERÓW UKŁADU    
  MUX0: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), SW(14 DOWNTO 12), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), SW(2 DOWNTO 0),SPACJA,SPACJA,SPACJA, M0);  
  
  MUX1: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), SW(2 DOWNTO 0),SPACJA,SPACJA,SPACJA,SW(14 DOWNTO 12), M1);
  
  MUX2: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), SW(2 DOWNTO 0),SPACJA,SPACJA,SPACJA, SW(14 DOWNTO 12), SW(11 DOWNTO 9), M2);
  
  MUX3: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), SW(5 DOWNTO 3), SW(2 DOWNTO 0),SPACJA,SPACJA,SPACJA,SW(14 DOWNTO 12), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), M3);
  
  MUX4: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), SW(2 DOWNTO 0),SPACJA,SPACJA,SPACJA, SW(14 DOWNTO 12), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), M4);
  
  MUX5: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), SPACJA,SPACJA,SPACJA, SW(14 DOWNTO 12), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), SW(2 DOWNTO 0), M5);
  
  MUX6: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15),SPACJA,SPACJA, SW(14 DOWNTO 12), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), SW(2 DOWNTO 0),SPACJA, M6);
  
  MUX7: mux3bit8to1 PORT MAP (SW(17 DOWNTO 15), SPACJA, SW(14 DOWNTO 12), SW(11 DOWNTO 9), 
  SW(8 DOWNTO 6), SW(5 DOWNTO 3), SW(2 DOWNTO 0),SPACJA,SPACJA, M7);
  
  -- KONKRETYZACJE KOLEJNYCH TRANSKODERÓW 
  H0: char7seg PORT MAP (M0, HEX0);
  H1: char7seg PORT MAP (M1, HEX1); 
  H2: char7seg PORT MAP (M2, HEX2);
  H3: char7seg PORT MAP (M3, HEX3);  
  H4: char7seg PORT MAP (M4, HEX4); 
  H5: char7seg PORT MAP (M5, HEX5); 
  H6: char7seg PORT MAP (M6, HEX6); 
  H7: char7seg PORT MAP (M7, HEX7); 
  
END strukturalna;
  
  
  
-- implementacja multipleksera 8 do 1 (wektor 3 bitowy) 
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux3bit8to1 IS
  PORT ( S, U0, U1, U2, U3, U4, U5,U6,U7: IN     STD_LOGIC_VECTOR(2 DOWNTO 0);
  M                   : OUT    STD_LOGIC_VECTOR(2 DOWNTO 0));
END mux3bit8to1;
  
  
ARCHITECTURE strukturalna OF mux3bit8to1 IS
BEGIN 

  -- niestandardowy multiplekser Greya w postaci równań
  M(0) <= (U0(0) and not S(2) and not S(1) and not S(0)) or (U1(0) and not S(2) and not S(1) and S(0))or 
    (U2(0) and not S(2) and S(1) and S(0))or (U3(0) and not S(2) and S(1) and not S(0)) or 
    (U4(0) and S(2) and S(1) and not S(0))or (U5(0) and S(2) and S(1) and S(0)) or 
    (U6(0) and S(2) and not S(1) and S(0))or (U7(0) and S(2) and not S(1) and not S(0));


  M(1) <= (U0(1) and not S(2) and not S(1) and not S(0)) or (U1(1) and not S(2) and not S(1) and S(0))or 
    (U2(1) and not S(2) and S(1) and S(0))or (U3(1) and not S(2) and S(1) and not S(0)) or 
    (U4(1) and S(2) and S(1) and not S(0))or (U5(1) and S(2) and S(1) and S(0)) or 
    (U6(1) and S(2) and not S(1) and S(0))or (U7(1) and S(2) and not S(1) and not S(0));

  M(2) <= (U0(2) and not S(2) and not S(1) and not S(0)) or (U1(2) and not S(2) and not S(1) and S(0))or 
    (U2(2) and not S(2) and S(1) and S(0))or (U3(2) and not S(2) and S(1) and not S(0)) or 
    (U4(2) and S(2) and S(1) and not S(0))or (U5(2) and S(2) and S(1) and S(0)) or 
    (U6(2) and S(2) and not S(1) and S(0))or (U7(2) and S(2) and not S(1) and not S(0));

  -- niestandardowy multiplekser Greya przy pomocy konstrukcji języka
  -- PROCESS(S, U0, U1, U2, U3, U4, U5, U6, U7)
    -- BEGIN
      -- CASE S IS
		  -- WHEN "000" => M <=U0;
		  -- WHEN "001" => M <=U1; 
		  -- WHEN "011" => M <=U2; 
		  -- WHEN "010" => M <=U3;
		  -- WHEN "110" => M <=U4;
		  -- WHEN "111" => M <=U5;
		  -- WHEN "101" => M <=U6;
		  -- WHEN "100" => M <=U7; 
      -- END CASE;
    -- END PROCESS; 
  
END strukturalna; 
  
  
-- IMPLEMENTACJA  TRANSKODERA 
LIBRARY ieee;
USE ieee.std_logic_1164.all;  

ENTITY char7seg IS     
	PORT ( C           : IN      STD_LOGIC_VECTOR(2 DOWNTO 0);             
	Display    : OUT     STD_LOGIC_VECTOR(0 TO 6));  
END char7seg;
  
  
ARCHITECTURE strukturalna OF char7seg IS 
BEGIN 
  --   . . . douzupełnienia; funkcje boolowskie 
  Display(0) <= (C(2) or C(1) or (not C(0) and not C(1)));	--a
  Display(1) <= (C(0) or(not C(2) and not C(1)));	--b
  Display(2) <= (not C(2) and not C(1) and not C(0)) or (C(2) and C(0)) or (C(1) and C(0));	--c
  Display(3) <= (C(1) or (not C(2) and not C(0)));	--d
  Display(4) <= (not C(1) and not C(0));	--e
  Display(5) <= (not C(1) and not C(0));	--f
  Display(6) <= (C(2) or (not C(1) and not C(0)) or (C(1) and C(0)));	--g
  
END strukturalna; 