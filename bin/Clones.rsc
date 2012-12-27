/**
 * Module        : Clones
 * Author        : Ioannis Tzanelis 
 * Description   : Calculates the duplication percentage of a Project 
 * 				   We calculate the dulication as the percentage 
 *				   of all code that occurs more than once in equal 
 *				   code blocks over 6 lines.               
 */

module Clones
		
import Prelude;
import IO;
import LOC;
import util::Math;
import Bar;

//* Instance Variables		
int totalLinesOfCode=0;
list[str] bigList=[];
list[int] poslist =[],zerolist =[], lastlist=[];
list[str] basicClones=[];

	    
	   
	    /**
     	* This method calculates the duplication of a project.
     	* @param locList all the .java file paths in a project.
     	* @return percentage the duplication percentage of a project.
     	*/
	    public real getDupResults(list[loc] locList){
	   			 tempList=[];
	   			 bigList=[];
	   	 		 counter=0;
	   	 		 
	     		 for(int i<-[0..size(locList)-1]){  //gets all lines from a .java file, removes comments and empty lines
	     			pureLinesOfProject=cleanFile(locList[i]);
	     			mergeAll7linesCombination( pureLinesOfProject);
	    		 }
	    		 
	    		counter=results(bigList);
	  			real percentage=rounder(counter,getLoc());
	   			return percentage;
	    }
	
		
		/**
     	* This method adds all the possible 6-line blocks in a .java file to the instance variable list[str] bigList
     	* @param allLines is a list with all pure lines of code of a .java file.
     	* @return Nothing.
     	*/	
		public void mergeAll7linesCombination(list[str] allLines){
		        list[str] strList=[];
		        linesOfJavaFile=size(allLines);
			    if( linesOfJavaFile>=7){
			    
					for( int z<-[0..( linesOfJavaFile-7)]){
							strList+=allLines[z]+allLines[z+1]+allLines[z+2]+allLines[z+3]+allLines[z+4]+allLines[z+5]+allLines[z+6];		
					}			
				    bigList+=strList;
		     	}
		}
			
			
				
		/**
     	* This method calculates the number of duplicate lines in a project.
     	* @param allSixLines a list[str] which contains all the possible 7-line blocks in a project.
     	* @return counter the number of duplicate lines in a project.
     	*/		
		public int results(list[str] allSixLines){
		        flag=false;
		        counter=0;
		        j=0;
			  	initSize=size(allSixLines);
				allDup=allSixLines-toList(toSet((allSixLines))); //all duplicates without first occurance
				//allDup+=dup(allDup);							//all duplicates with the first occurance
				basicClones=dup(allDup);
				update(0,0.0,"",0);  //* Update Progress bar
				
				for(int i<-[0..size(allSixLines)-1]){
					if (flag==false) {zerolist+=j;j=0;}
					if((allSixLines[i] in allDup) && flag==true){  //if the duplicate blocks are consecutive we add only 1 line
							allDup-=allSixLines[i];
							counter+=1;
							j+=1;	
					}
					else if((allSixLines[i]) in allDup){			//if the duplicate blocks are not consecutive we add the whole block
							allDup-=allSixLines[i];
							flag=true;
							counter+=7;
							j+=7;
							poslist+=(i+1);
					}
					else {flag=false;
					        }

				}
				for(i <-[0..size(zerolist)-1]){
					if (zerolist[i] !=  0) {
					lastlist +=zerolist[i];
					}
				}
			//	pame =[<poslist[i], lastlist[i]> | int i <- [0 .. size(poslist)-1]];
		    update(0,0.0,"",0);  //* Update Progress bar
		//    println(sum(lastlist));
		//    println(counter);	
			return counter;
				
				
		}
	   /**
     	* This method calculates the percentage of a number of lines in a project and rounds it to 2 decimal digits.
     	* @param numOfLines the number of lines that we need to calculate their percentage.
     	* @param LOC the total number of pure lines of code in current analyzed project
     	* @return the rounded percentage of duplication.
     	*/			
	  public real rounder(int numOfLines,int LOC){
	  		   return round((numOfLines/(toReal(LOC)))*100,0.1);
	   }
		public list[int] clonePosition(){
     	    	return poslist;
     	    }
  	  public list[int] cloneSize(){
    			return lastlist;
    		}
    		
    		public list[str] getAll7Lines(){
    				return bigList;
    		}
    		
    		public list[str] getClones(){
    				return basicClones;
    		}