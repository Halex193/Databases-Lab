### Electronics Shop Database

-PC types m:m employees (PC tests)  
-CPU types 1:m PC types  
-hard drive types 1:m PC types  
-motherboard types 1:m PC types  
-power supply types 1:m PC types  
-ram types 1:m PC types  

-keyboard types

-customers 1:m orders  
-employees  m:m employees (PC types)  
-orders m:m products  
-products m:m orders  

-PC tests m:m (PC types | employees)