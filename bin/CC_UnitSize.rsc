/**
 * Module        : CC_UnitSize 
 * Author        : Ioannis Tzanelis 
 * Description   : Calculates the Cyclomatic Complexity and Unit Size of a Project                
 */

module CC_UnitSize
		
import Prelude;
import IO;
import util::Resources;
import Clones;
import LOC;
import util::Math;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import Bar;
import vis::Render;
import vis::Figure;
import vis::KeySym;
import vis::Chart;

//* Instance Variables				
list[int] ccList=[], unitSizeList=[], ccbuffer=[];
list[str] nameList=[];
int unitSize=0;
list[int] colorCC=[];
list[int] colorCCFinal=[];
list[int] methodcount=[];
list[int] widthList =[];
list[loc] uriList=[];
		   
	   /**
     	* This method calculates the c.complexity of every method and adds it to the instance variable list[int] ccList.
     	* In parallel calculates the size of every method in a project and adds it to the instance variable unitSizeList.
     	* @param paths all the .java file paths in a project.
     	* @return Nothing.
     	*/	
		    public void setComlexityOfUnits(list[loc] paths){ 
		   			 astList=[];
		   			 unitSizeList=[];
		   			 ccList=[];
		   			 nameList=[];
		   			 uriList=[];
		   			/*Create a list with the AST of every file  */
		   			 for( i<-[0..size(paths)-1])  astList+=createAstFromFile(paths[i]);
		   			         update(0,0.0,"",0);  //* Update Progress bar
		 					 for( i<-[0..size(astList)-1]){
		 					 	 colorCC=[];
		 					 	 methodcount=[];
		                          /*Visit all the AST's in order*/
		  							visit(astList[i]){
		  							 			
		   									case  u:methodDeclaration(_,_,_,_,name,_,_,methodsSubtree): {
		   												methodcount +=1;
		               									int cc = 1;
		               									nameList += name;
							
		               									/*In case of a method declaration visit its subtree */
		           				 						visit(methodsSubtree) {
		            											  
	                                                              //* Statements that change the path
	                                                               case ifStatement(_, _, _): cc += 1;
                                                                   case forStatement(_, _, _, _):cc += 1;
                                                                   case enhancedForStatement(_, _, _):cc += 1;
                                                                   case doStatement(_, _): cc += 1;
                                                                   case switchCase(bool isDefault, _): cc += 1;
                                                                   case catchClause(_, _): cc += 1; 
                                                                   case whileStatement(_, _): cc += 1;
                                                                   case infixExpression(str operator, _, _, _):  {if ((operator == "||") || (operator == "&&")) cc += 1;}
		              									 };	
		              									
		           										ccList+=cc;
		           										colorCC+=cc;
		             									unitSizeList += (size(cleanFile(u@location))+1);
		             									 uriList+=u@location;
		        										
		             									
		              						}
		              						
		    					  }
		    					 widthList+= size(methodcount);
		    					  	 if(colorCC==[]) colorCCFinal+=1;
		    					  else colorCCFinal+=max(colorCC);
		    					  
		  					 }
		  					 update(0,0.0,"",0);  //* Update Progress bar
			 }
		 
		 
		   /**
     	    * This method calculates the Cyclomatic Complexity of a java project according to SIG Model..
     	    * @param paths all the .java file paths in a project.
     	    * @return the percentage of CC of every category(moderate,high,very high).
     	    */
			public list[real] getCC(list[loc] paths){
					
					totalLines = getLoc();
					setComlexityOfUnits(paths);
					int moderate =0,high=0,veryhigh =0;
					update(0,0.0,"",0);  //* Update Progress bar
					for(int i<-[0..size(ccList)-1]){
							 if (ccList[i] >10 && ccList[i] <=20) moderate+=unitSizeList[i];
		  					 else if (ccList[i] >20 && ccList[i] <=50) high+=unitSizeList[i];
							 else if (ccList[i] >50) veryhigh+=unitSizeList[i];
					}
					
					unitSize=toInt(sum(unitSizeList));
		            return [rounder(moderate,totalLines),rounder(high,totalLines),rounder(veryhigh,totalLines)];
			}
			
			
				/**
     	    * This method calculates the Unit sizes of a java project
     	    * The papper from SIG did not offer clear instructions in order to create
     	    * the risk groups so we used the sime categories as the Cyclomatic Complexity
     	    * @param nothing
     	    * @return the percentage of lines of code that are included in a method
     	    * of every category(moderate,high,very high).
     	    */
			public list[real] getUnitCategories(){
					
					totalLines = getLoc();
					
					int moderate =0,high=0,veryhigh =0;
					
					for(int i<-[0..size(unitSizeList)-1]){
							 if (unitSizeList[i] >20 && unitSizeList[i] <=50) moderate+=unitSizeList[i];
		  					 else if (unitSizeList[i] >50 && unitSizeList[i] <=100) high+=unitSizeList[i];
							 else if (unitSizeList[i] >100) veryhigh+=unitSizeList[i];
					}
					
		            return [rounder(moderate,totalLines),rounder(high,totalLines),rounder(veryhigh,totalLines)];
			}
		
            /**
     	    * This method gets the already calculated total size of methods in lines of code
     	    * @param Nothing.
     	    * @return unitSize the total size of methods in lines of code.
     	    */
     	
     	    public list[int] getCCofUnit(){
     	    	return ccList;
     	    }
     	     public list[int] getClassWidth(){
     	    	return widthList;
     	    }
     	    public list[int] getUnitSizeList(){
     	    	return unitSizeList;
     	    }
     	    public list[str] getmethodName(){
     	    	return nameList;
     	    }

			public int getUnitSize(){
			    update(0,0.0,"",0);  //* Update Progress bar
				return unitSize;
			}
			
			public list[int] getCcColor(){
					return colorCCFinal;
			} 
			
			public list[loc] getUriList(){
			     return uriList;
			}