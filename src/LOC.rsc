/**
 * Module        : LOC 
 * Author       : Ioannis Tzanelis 
 * Description   : Calculates the total "clean" lines of code of a project                
 */
 

module LOC
	
import Prelude;
import IO;
import Bar;
	
//* Instance Variables		
int lines=0;
list[int] vizFileSize=[];

	   /**
     	* This method calculates the pure lines in code of a project.
     	* @param pathList all the .java file paths in a project.
     	* @return sum the total size of a project in lines of code.
     	*/
	 public int getLinesOfProject(list[loc] pathList){
	   			int sum=0;
	   			
	   			update(0,0.0,"",0);  //* Update Progress bar
	   			for(i <-[0..size(pathList)-1]){ 
	   						
	   						vizFileSize+=size(cleanFile(pathList[i]));
	   						sum+=last(vizFileSize);
	   						
	   			}
	   			lines=sum;
	   			return sum;
	   }
	

	   /**
     	* This method removes all empty lines and comments in a .java file.
     	* @param filePath the file path of a .java file.
     	* @return lines a list with every pure line in a .java file as a string.
     	*/
	  	public list[str] cleanFile(loc filePath){
        		listTemp=readFileLines(filePath);
        		cleanList=[];
        		flag=false;
   
      			for ( int i <- [0..size(listTemp)-1]) {
      					trimmedLine=trim(listTemp[i]);
          				if(isEmpty(trim(trimmedLine)));
         				else if (startsWith(trimmedLine,"/*") && flag==false && endsWith(trimmedLine,"*/")) flag=false;
          				else if ((startsWith(trimmedLine,"/*")  && flag==false )) flag=true;
             			else if (contains(trimmedLine,"/*") && flag==false && !contains(trimmedLine,"*/") ) { cleanList=cleanList+ trimmedLine; flag=true;}
          				else if (endsWith(trimmedLine,"*/") && flag==true) flag=false;
          				else if (startsWith(trimmedLine,"//") );
          				else if (flag==false) cleanList=cleanList+ trimmedLine; 
         		}
      			return cleanList;
   		}
	  
	  
	  /**
     	* This method returns the already calculated number of pure lines of code in current project.
     	* @param Nothing.
     	* @return lines the number of pure lines of code of current analyzed project..
     	*/
	  public int getLoc(){
	  			return lines;
	  }
	  
  public list[int] getFileSizeList(){
	  			return vizFileSize;
	  }