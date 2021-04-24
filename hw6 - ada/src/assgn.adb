with Ada.Text_IO, Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random; use Ada.Text_IO;
package body Assgn is 
   --initialize first array (My_Array) with random binary values
   procedure Init_Array (Arr: in out BINARY_ARRAY) is 
      package random_binaryVal is new Ada.Numerics.Discrete_Random(BINARY_NUMBER);
      use random_binaryVal;
      G: Generator;
   begin
      Reset (G);
      for Index in 1..16 loop
         Arr(Index) := Random(G);
      end loop;
   end;

   --reverse binary array
   procedure Reverse_Bin_Arr (Arr : in out BINARY_ARRAY) is  
      My_Array :BINARY_ARRAY;
      Index :Integer;
   begin      
       Index := 1;
      for Index1 in reverse 1..16 loop          
         My_Array(Index) := Arr(Index1); 
         Index := Index + 1;
      end loop; 
       
      for Index2 in 1..16 loop
         Arr(Index2) := My_Array(Index2);
      end loop;
   end;
     
   
   --print an array
   procedure Print_Bin_Arr (Arr : in BINARY_ARRAY) is
   begin
        for Index in 1..16 loop
           Put(BINARY_NUMBER'Image(Arr(Index)));
         end loop; 
   end;
     

   --Convert Integer to Binary Array
   function Int_To_Bin(Num : in INTEGER) return BINARY_ARRAY is
      My_Array :BINARY_ARRAY;
      Int :INTEGER;
      begin 
         Int := Num;
      for Index in 1..16 loop
               if (Int rem 2 = 0) then
               My_Array(Index) := 0;
               Int := Int/2;
               elsif(Int rem 2 = 1) then
               My_Array(Index) := 1;
               Int := Int/2;
              end if;            
      end loop;       
      Reverse_Bin_Arr(My_Array);
      return My_Array;
      end;       
       
     

   --convert binary number to integer
   function Bin_To_Int (Arr : in BINARY_ARRAY) return INTEGER is
      My_Array :BINARY_ARRAY;
      Num :INTEGER;
   begin
      My_Array := Arr;
      Reverse_Bin_Arr(My_Array);
      Num := 0;
      for Index in 1..16 loop 
      Num := (My_Array(Index) * 2**(Index-1)) + Num;
      end loop;
    return Num;
    end;
     

   --overloaded + operator to add two BINARY_ARRAY types together
   function "+" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
      First_Array :BINARY_ARRAY;
      Second_Array :BINARY_ARRAY;
      Sum_Array    :BINARY_ARRAY;
      Carry :Integer;
    begin
      First_Array := Left;
      Second_Array := Right;
      Carry := 0;  
      for Index in reverse 1..16 loop    
         if ((First_Array(Index) = 1 and Second_Array(Index) = 0) or (First_Array(Index) = 0 and Second_Array(Index) = 1) or (First_Array(Index) = 0 and Second_Array(Index) = 0)) then
            Sum_Array(Index) := First_Array(Index) + Second_Array(Index);
            if (Carry = 1 and Sum_Array(Index) = 1) then
               Sum_Array(Index) := 0;
            elsif (Carry = 1 and Sum_Array(Index) = 0) then
               Sum_Array(Index) := 1;
               Carry := 0;
            end if;
          
         elsif ((First_Array(Index) = 1 and Second_Array(Index) = 1)) then
            if (Carry = 1) then               
            Sum_Array(Index) := 1; 
            else 
            Sum_Array(Index) := 0;
            Carry := 1; 
            end if;
         end if;       
       
      end loop;
      return Sum_Array;
    end;      
   
    --overloaded + operator to add an INTEGER type and a BINARY_ARRAY type together
     function "+" (Left : in INTEGER;
                     Right : in BINARY_ARRAY) return BINARY_ARRAY is 
      First :INTEGER;
      First_Array :BINARY_ARRAY;
      Second_Array :BINARY_ARRAY;
      Sum_Array :BINARY_ARRAY;      
     begin
      First := Left;
      First_Array := Int_To_Bin(First);
      Second_Array:= Right;
      Sum_Array := First_Array + Second_Array;
      return Sum_Array;
     end;


   --overloaded - operator to subtract one BINARY_ARRAY type from another			 
   function "-" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
    First_Array :BINARY_ARRAY;
      Second_Array :BINARY_ARRAY;
      Diff_Array    :BINARY_ARRAY;
      Carry :Integer;
      First_Num :INTEGER;
      Second_Num :INTEGER;
    begin
      First_Array := Left;
      Second_Array := Right;
      First_Num := Bin_To_Int(First_Array);
      Second_Num := Bin_To_Int(Second_Array);
      Carry := 0;  
      for Index in reverse 1..16 loop    
         if ((First_Array(Index) = 1 and Second_Array(Index) = 0) or (First_Array(Index) = 1 and Second_Array(Index) = 1)) then
            if (First_Num < Second_Num) then
            Diff_Array(Index) := Second_Array(Index) - First_Array(Index); 
            else
               Diff_Array(Index) := First_Array(Index) - Second_Array(Index);
            end if;
            if (Carry = 1 and First_Array(Index) = 1) then
               if(Second_Array(Index) = 1) then
               Diff_Array(Index) := 1;
               elsif(Second_Array(Index) = 0) then
               Diff_Array(Index) := 0;
               Carry := 0;
               end if;
            elsif (Carry = 1 and Diff_Array(Index) = 0) then
               Diff_Array(Index) := 1;
            end if;
         elsif (First_Array(Index) = 0 and Second_Array(Index) = 0) then
            if (Carry = 1) then
               Diff_Array(Index) := 1;
            else 
               Diff_Array(Index) := 0;
            end if;
         elsif ((First_Array(Index) = 0 and Second_Array(Index) = 1)) then
            if (Carry = 1) then               
            Diff_Array(Index) := 0; 
            else 
            Diff_Array(Index) := 1;
            Carry := 1; 
            end if;
         end if;       
       
      end loop;
      return Diff_Array;
   end;
     

   --overloaded - operator to subtract a BINARY_ARRAY type from an INTEGER type
    function "-" (Left : in Integer;
                  Right : in BINARY_ARRAY) return BINARY_ARRAY is
      First :INTEGER;
      First_Array :BINARY_ARRAY;
      Second_Array :BINARY_ARRAY;
      Diff_Array :BINARY_ARRAY;      
     begin
      First := Left;
      First_Array := Int_To_Bin(First);
      Second_Array:= Right;
      Diff_Array := First_Array - Second_Array;
      return Diff_Array;
     end;
     
        

end Assgn;
