-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- CONTAINS SOLUTION CODE TOO, not JUST imports

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `sql_sudoku`
--

DELIMITER $$
--
-- Függvények
--
DROP FUNCTION IF EXISTS `can_go_there`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `can_go_there` (`what` TEXT, `yrow` INT, `xcol` INT, `input` TEXT) RETURNS INT DETERMINISTIC BEGIN
    DECLARE solution INT DEFAULT 1;
    DECLARE temp TEXT DEFAULT '0';
    DECLARE size INT DEFAULT 9;

    DECLARE y INT DEFAULT 0;
    DECLARE x INT DEFAULT 0;
    DECLARE vert INT DEFAULT 0;
    DECLARE vert2 INT DEFAULT 9;

    SET temp = SUBSTRING(input, yrow * 9 + 1 + xcol, 1);
    IF temp NOT LIKE '0' THEN
        SET solution = 0;
    END IF;

    IF solution = 1 THEN
        col_loop: LOOP
            IF x = size THEN
                LEAVE col_loop;
            END IF;

            SET temp = SUBSTRING(input, yrow * 9 + 1 + x, 1);
            IF temp LIKE what AND x != xcol THEN
                SET solution = 0;
                LEAVE col_loop;
            END IF;

            SET x = x + 1;
            IF x=size THEN
           	 LEAVE col_loop;
            END IF;
        END LOOP col_loop;
    END IF;

    IF solution = 1 THEN
        row_loop: LOOP
            IF y = size THEN
                LEAVE row_loop;
            END IF;

            SET temp = SUBSTRING(input, y * 9 + 1 + xcol, 1);
            IF temp LIKE what AND y != yrow THEN
                SET solution = 0;
                LEAVE row_loop;
            END IF;

            SET y = y + 1;
            IF y=size THEN
           	 LEAVE row_loop;
            END IF;
        END LOOP row_loop;
    END IF;

    -- Diagonal checks
    IF xcol = yrow THEN
        SET vert = 0;

        vert_loop: LOOP
            IF vert = size THEN
                LEAVE vert_loop;
            END IF;

            SET temp = SUBSTRING(input, vert * 9 + 1 + vert, 1);
            IF temp LIKE what AND vert != yrow THEN
                SET solution = 0;
                LEAVE vert_loop;
            END IF;

            SET vert = vert + 1;
             IF vert=size THEN
           	 LEAVE vert_loop;
            END IF;
        END LOOP vert_loop;

        SET vert = 0;
        SET vert2 = 8;

        vert_loop2: LOOP
            IF vert = size THEN
                LEAVE vert_loop2;
            END IF;

            SET temp = SUBSTRING(input, vert * 9 + 1 + vert2, 1);
            IF temp LIKE what AND (vert != yrow OR vert2 != xcol) THEN
                SET solution = 0;
                LEAVE vert_loop2;
            END IF;

            SET vert = vert + 1;
            SET vert2 = vert2 - 1;
            IF vert=size THEN
           	 LEAVE vert_loop2;
            END IF;
        END LOOP vert_loop2;
    END IF;

    RETURN solution;
END$$

DROP FUNCTION IF EXISTS `no_of_years`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `no_of_years` (`date1` DATE) RETURNS INT DETERMINISTIC BEGIN
 DECLARE date2 DATE;
  Select current_date()into date2;
  RETURN year(date2)-year(date1);
END$$

DROP FUNCTION IF EXISTS `solve_sql`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `solve_sql` (`input` TEXT) RETURNS TEXT CHARSET utf8mb4 DETERMINISTIC BEGIN
 	DECLARE solution text DEFAULT "";
    DECLARE empties int DEFAULT 0;
    DECLARE size int DEFAULT 9;
    DECLARE i int DEFAULT 0;
    DECLARE temp text DEFAULT "";
    
    SET solution = input;
    
    i_loop: LOOP

            SET temp = SUBSTRING(input, i, 1);
            IF temp LIKE "0" THEN
                set empties = empties+1;
            END IF;

            SET i = i + 1;
            IF i=size*size THEN
            	LEAVE i_loop;
            END IF;
        END LOOP i_loop;
        
    SET i=0;
    i_loop2: LOOP
		SET solution = solve_sql_one_iter(solution);
        SET i = i + 1;
        IF i=empties-1 THEN
            LEAVE i_loop2;
        END IF;
    END LOOP i_loop2;
    
  	RETURN solution;
END$$

DROP FUNCTION IF EXISTS `solve_sql_one_iter`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `solve_sql_one_iter` (`input` TEXT) RETURNS TEXT CHARSET utf8mb4 DETERMINISTIC BEGIN
 	DECLARE solution text DEFAULT "";
    DECLARE temp_row text DEFAULT "";
    DECLARE size int DEFAULT 9;
    
    DECLARE y int DEFAULT 0;
    DECLARE x int DEFAULT 0;
    
    DECLARE canplace int DEFAULT 0;
    DECLARE possibles text DEFAULT 0;
    
    row_loop: LOOP
    	 SET temp_row = "";
         
         col_loop: LOOP
             set possibles="";
         	 set canplace=can_go_there("1",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"1");
             END IF;
             
             set canplace=can_go_there("2",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"2");
             END IF;
             
             set canplace=can_go_there("3",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"3");
             END IF;
             
             set canplace=can_go_there("4",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"4");
             END IF;
             
             set canplace=can_go_there("5",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"5");
             END IF;
             
             set canplace=can_go_there("6",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"6");
             END IF;
             
             set canplace=can_go_there("7",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"7");
             END IF;
             
             set canplace=can_go_there("8",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"8");
             END IF;
             
             set canplace=can_go_there("9",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"9");
             END IF;
             
             IF LENGTH(possibles)=1 THEN
				set temp_row=CONCAT(temp_row,possibles);
             ELSE
             	set temp_row=CONCAT(temp_row,SUBSTRING(input, y * 9 + 1 + x, 1));
             END IF;
             
             set x = x+1;
             IF x=size THEN
                LEAVE col_loop;
             END IF;
         END LOOP col_loop;
         
         set x = 0;
         set y = y+1;
         set solution = CONCAT(solution,temp_row);
         IF y=size THEN
            LEAVE row_loop;
         END IF;
    END LOOP row_loop;
 
  	/*SELECT SUBSTRING_INDEX(input,'|',1) into row1;
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',2) into row2;
    SET row2=substr(row2,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',3) into row3;
    SET row3=substr(row3,2);
   	SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',4) into row4;
    SET row4=substr(row4,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',5) into row5;
    SET row5=substr(row5,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',6) into row6;
    SET row6=substr(row6,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',7) into row7;
    SET row7=substr(row7,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',8) into row8;
    SET row8=substr(row8,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',-1) into row9;
    SET row9=substr(row9,2);*/
    
  	RETURN solution;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `puzzle`
--

DROP TABLE IF EXISTS `puzzle`;
CREATE TABLE IF NOT EXISTS `puzzle` (
  `A` int NOT NULL,
  `B` int NOT NULL,
  `C` int NOT NULL,
  `D` int NOT NULL,
  `E` int NOT NULL,
  `F` int NOT NULL,
  `G` int NOT NULL,
  `H` int NOT NULL,
  `I` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- A tábla adatainak kiíratása `puzzle`
--

INSERT INTO `puzzle` (`A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`, `I`) VALUES
(0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 0, 0, 7, 0, 9, 0, 0, 0),
(0, 0, 6, 0, 3, 0, 9, 0, 0),
(0, 6, 0, 2, 0, 5, 0, 1, 0),
(0, 0, 5, 9, 0, 6, 3, 0, 0),
(0, 1, 0, 0, 4, 8, 0, 9, 0),
(0, 0, 7, 0, 8, 0, 5, 0, 0),
(0, 0, 0, 4, 0, 7, 0, 0, 0),
(8, 0, 0, 0, 0, 0, 0, 0, 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


-- THE CODE FOR THE SOLVING:

DROP FUNCTION IF EXISTS solve_sql;
DROP FUNCTION IF EXISTS solve_sql_one_iter;
DROP FUNCTION IF EXISTS can_go_there;

DELIMITER //

CREATE FUNCTION can_go_there(what TEXT, yrow INT, xcol INT, input TEXT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE solution INT DEFAULT 1;
    DECLARE temp TEXT DEFAULT '0';
    DECLARE size INT DEFAULT 9;

    DECLARE y INT DEFAULT 0;
    DECLARE x INT DEFAULT 0;
    DECLARE vert INT DEFAULT 0;
    DECLARE vert2 INT DEFAULT 9;
    
    DECLARE cellx int DEFAULT 0;
    DECLARE celly int DEFAULT 0;
    IF yrow > 2 and yrow <6 THEN
    	set celly=3;
    ELSEIF yrow > 5 THEN
    	set celly=6;
    END IF;
    IF xcol > 2 and xcol <6 THEN
    	set cellx=3;
    ELSEIF xcol > 5 THEN
    	set cellx=6;
    END IF;

    SET temp = SUBSTRING(input, yrow * 9 + 1 + xcol, 1);
    IF temp NOT LIKE '0' THEN
        SET solution = 0;
    END IF;

    IF solution = 1 THEN
        col_loop: LOOP
            IF x = size THEN
                LEAVE col_loop;
            END IF;

            SET temp = SUBSTRING(input, yrow * 9 + 1 + x, 1);
            IF temp LIKE what AND x != xcol THEN
                SET solution = 0;
                LEAVE col_loop;
            END IF;

            SET x = x + 1;
            IF x=size THEN
           	 LEAVE col_loop;
            END IF;
        END LOOP col_loop;
    END IF;

    IF solution = 1 THEN
        row_loop: LOOP
            IF y = size THEN
                LEAVE row_loop;
            END IF;

            SET temp = SUBSTRING(input, y * 9 + 1 + xcol, 1);
            IF temp LIKE what AND y != yrow THEN
                SET solution = 0;
                LEAVE row_loop;
            END IF;

            SET y = y + 1;
            IF y=size THEN
           	 LEAVE row_loop;
            END IF;
        END LOOP row_loop;
    END IF;
    
    IF solution = 1 THEN
        SET cellx = (xcol DIV 3) * 3;
        SET celly = (yrow DIV 3) * 3;

        SET y = celly;
        box_row_loop: WHILE y < celly + 3 DO
        SET x = cellx;
        box_col_loop: WHILE x < cellx + 3 DO
            SET temp = SUBSTRING(input, y * 9 + 1 + x, 1);
            IF temp = what AND NOT (y = yrow AND x = xcol) THEN
                SET solution = 0;
                LEAVE box_row_loop;
            END IF;
            SET x = x + 1;
        END WHILE box_col_loop;
        SET y = y + 1;
    END WHILE box_row_loop;
    END IF;

    -- Diagonal checks
    IF xcol = yrow THEN
        SET vert = 0;

        vert_loop: LOOP
            IF vert = size THEN
                LEAVE vert_loop;
            END IF;

            SET temp = SUBSTRING(input, vert * 9 + 1 + vert, 1);
            IF temp LIKE what AND vert != yrow THEN
                SET solution = 0;
                LEAVE vert_loop;
            END IF;

            SET vert = vert + 1;
             IF vert=size THEN
           	 LEAVE vert_loop;
            END IF;
        END LOOP vert_loop;

        SET vert = 0;
        SET vert2 = 8;

        vert_loop2: LOOP
            IF vert = size THEN
                LEAVE vert_loop2;
            END IF;

            SET temp = SUBSTRING(input, vert * 9 + 1 + vert2, 1);
            IF temp LIKE what AND (vert != yrow OR vert2 != xcol) THEN
                SET solution = 0;
                LEAVE vert_loop2;
            END IF;

            SET vert = vert + 1;
            SET vert2 = vert2 - 1;
            IF vert=size THEN
           	 LEAVE vert_loop2;
            END IF;
        END LOOP vert_loop2;
    END IF;

    RETURN solution;
END
//

DELIMITER ;

DELIMITER //

CREATE FUNCTION solve_sql_one_iter(input text) RETURNS text DETERMINISTIC
BEGIN
 	DECLARE solution text DEFAULT "";
    DECLARE temp_row text DEFAULT "";
    DECLARE size int DEFAULT 9;
    
    DECLARE y int DEFAULT 0;
    DECLARE x int DEFAULT 0;
    
    DECLARE canplace int DEFAULT 0;
    DECLARE possibles text DEFAULT 0;
    
    row_loop: LOOP
    	 SET temp_row = "";
         
         col_loop: LOOP
             set possibles="";
         	 set canplace=can_go_there("1",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"1");
             END IF;
             
             set canplace=can_go_there("2",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"2");
             END IF;
             
             set canplace=can_go_there("3",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"3");
             END IF;
             
             set canplace=can_go_there("4",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"4");
             END IF;
             
             set canplace=can_go_there("5",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"5");
             END IF;
             
             set canplace=can_go_there("6",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"6");
             END IF;
             
             set canplace=can_go_there("7",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"7");
             END IF;
             
             set canplace=can_go_there("8",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"8");
             END IF;
             
             set canplace=can_go_there("9",y,x,input);
             IF canplace = 1 THEN
             	set possibles = CONCAT(possibles,"9");
             END IF;
             
             IF LENGTH(possibles)=1 THEN
				set temp_row=CONCAT(temp_row,possibles);
             ELSE
             	set temp_row=CONCAT(temp_row,SUBSTRING(input, y * 9 + 1 + x, 1));
             END IF;
             
             set x = x+1;
             IF x=size THEN
                LEAVE col_loop;
             END IF;
         END LOOP col_loop;
         
         set x = 0;
         set y = y+1;
         set solution = CONCAT(solution,temp_row);
         IF y=size THEN
            LEAVE row_loop;
         END IF;
    END LOOP row_loop;
 
  	/*SELECT SUBSTRING_INDEX(input,'|',1) into row1;
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',2) into row2;
    SET row2=substr(row2,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',3) into row3;
    SET row3=substr(row3,2);
   	SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',4) into row4;
    SET row4=substr(row4,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',5) into row5;
    SET row5=substr(row5,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',6) into row6;
    SET row6=substr(row6,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',7) into row7;
    SET row7=substr(row7,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',8) into row8;
    SET row8=substr(row8,2);
    SELECT REPLACE(input,SUBSTRING_INDEX(input,'|',1),"") into input;
    SELECT SUBSTRING_INDEX(input,'|',-1) into row9;
    SET row9=substr(row9,2);*/
    
  	RETURN solution;
END 

//

DELIMITER ;

DELIMITER //

CREATE FUNCTION solve_sql(input text) RETURNS text DETERMINISTIC
BEGIN
 	DECLARE solution text DEFAULT "";
    DECLARE solution_formatted text DEFAULT "";
    DECLARE empties int DEFAULT 0;
    DECLARE size int DEFAULT 9;
    DECLARE i int DEFAULT 0;
    DECLARE temp text DEFAULT "";
    
    SET solution = input;
    
    i_loop: LOOP

            SET temp = SUBSTRING(input, i, 1);
            IF temp LIKE "0" THEN
                set empties = empties+1;
            END IF;

            SET i = i + 1;
            IF i=size*size THEN
            	LEAVE i_loop;
            END IF;
        END LOOP i_loop;
        
    SET i=0;
    i_loop2: LOOP
		SET solution = solve_sql_one_iter(solution);
        SET i = i + 1;
        IF i=empties-1 THEN
            LEAVE i_loop2;
        END IF;
    END LOOP i_loop2;
    
    SET solution_formatted = CONCAT(substring(solution,1,9),"\n",substring(solution,1+9,9),"\n",substring(solution,1+18,9),"\n",substring(solution,1+27,9),"\n",substring(solution,1+36,9),"\n",substring(solution,1+45,9),"\n",substring(solution,1+54,9),"\n",substring(solution,1+63,9),"\n",substring(solution,1+72,9),"\n");
  	RETURN solution_formatted;
END 
//

DELIMITER ;

SHOW WARNINGS;

SELECT solve_sql(REPLACE(GROUP_CONCAT(`A`,`B`,`C`,`D`,`E`,`F`,`G`,`H`,`I`),",","")) FROM `puzzle` WHERE 1;