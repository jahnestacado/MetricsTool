/**
 * Module        : Main
 * Authors       : Ioannis Tzanelis, Georgios Kalaitzoglou  
 * Description   : Calls the metric modules and prints the corresponding results
 *				   Also calculates ranking based on the SIG ranking scheme               
 */
 
module Main

import IO;
import lang::java::jdt::JDT;
import util::Resources;
import Prelude;
import LOC;
import Clones;
import CC_UnitSize;
import Bar;
import Logo;
import viz;


	
//* Instance Variables			
list[loc] locList=[];
int totaloc = 0;
loc path=|project://SmallSQL|;
bool c = false;
list[str] classNameList=[];
int totalLoc = 0;
real totalDup =0.0;
list[real] ccCategories = [];
int totalUnSize = 0;

        /**
     	* Main() calls all the needed functions in order to print the results of analyzed project.
     	* @return Nothing.
     	*/
		public void main(){
			  locList=[];
			  showLogo();   //* Display Rascal Logo
			  printBanner();  //* Print Rascal banner
			  for(int i<-[0..900000]);
			  banner("Loading files...");
	  		  pro=extractProject(path);
			  visit(pro){ 	case file(loc l): checkJava(l);}
			  banner("Calculating Metrics...");
			  
			  //* Print all results	
			  totalLoc=getLinesOfProject(locList);
			  print("LOC: <totalLoc>");
			  printLocRating(totalLoc);
			  update(totalLoc,0.0,"",0);  //* Update Progress bar
			          	 
			  println("");
        	  totalDup=getDupResults(locList);
        	  print("Duplication :<totalDup>%");
        	  printDupRating(totalDup);
        	  update(0,totalDup,"",0);  //* Update Progress bar
        	          	
        	  println("");
          	  ccCategories=getCC(locList);
		  	  print("Complexity[moderate: <ccCategories[0]>%,high: <ccCategories[1]>%,very high: <ccCategories[2]>%]");
		  	  printCatRating(ccCategories);
		  	  cc="\n   mod: <ccCategories[0]>%,\n   h: <ccCategories[1]>%,\n   v.h: <ccCategories[2]>%";
		  	  update(0,0.0,cc,0);  //* Update Progress bar
		  	  
		  	  println("");
		  	  unitCategories=getUnitCategories();
		  	  print("Total Unit Size: <getUnitSize()>");
		  	  totalUnSize = getUnitSize();
		  	  print(" / Unit Size[moderate: <unitCategories[0]>%,high: <unitCategories[1]>%,very high: <unitCategories[2]>%]");
		  	  printCatRating(unitCategories);
		  	  update(0,0.0,"",getUnitSize());  //* Update Progress bar
		 	 // dupoutline (getLoc(),clonePosition(),cloneSize());  //Outline
		 	// newDup();
			getPreview(getFileSizeList(),classNameList,locList,getClassWidth());
	
 	
		}
	
	public int getTotalLoc(){
			     return totalLoc;
			}
	
		public real getTotalDup(){
			     return totalDup;
			}
	
	public list[real] getCCOveral(){
				return ccCategories;
	}
	public int getTotUnSize(){
				return totalUnSize;
	}
    	/**
     	* This method checks if input parameter is a java file  and adds it to instance variable locList.
     	* @param path file path.
     	* @return Nothing.
     	*/
	public void checkJava(loc path){
				if(contains(path.uri,".java")){
						 locList=locList+path;
						 int strStart=findLast(path.uri, "/")+1;
						 int strEnd=findLast(path.uri, ".");
						 classNameList+=substring(path.uri, strStart, strEnd);
						 
				}
		}
		
		/**
     	* This method receives the total lines of clean code and calculates the ranking according to
     	* the Sig ranking scheme
     	* @param int total lines of clean code.
     	* @return string Ranking category.
     	*/
		public void printLocRating(int totaloc){
		
		 if( totaloc < 66000 ){
			  		print(" / Rating: ++");
			  }
			  else if( totaloc < 246000 ){
			  		print(" / Rating: +");
			  }
			  else if( totaloc < 665000 ){
			  		print(" / Rating: o");
			  }
			  else if( totaloc < 1310000 ){
			  		print(" / Rating: -");
			  }
			  else{
			  		print(" / Rating: --");
			  }
		
		}
		
		/**
     	* This method receives duplication percentage and calculates the ranking according to
     	* the Sig ranking scheme
     	* @param real total duplication of the project.
     	* @return string Ranking category.
     	*/
		public void printDupRating(real totalDup){
		if (totalDup < 3.0){
        	  		print(" / Rating: ++");
        	  }
        	  else if (totalDup < 5.0){
        	  		print(" / Rating: +");
        	  }
        	  else if (totalDup < 10.0){
        	  		print(" / Rating: o");
        	  }
        	  else if (totalDup < 20.0){
        	  		print(" / Rating: -");
        	  }
        	  else{
        	  		print(" / Rating: --");
        	  }
		
		}
		
		/**
     	* This method receives the Cyclomatic Complexity and Unit size results 
     	* and calculates the ranking according to Sig ranking scheme
     	* we decided to use a the same ranking scheme for Unit Sizes as in Cyclomatic Complexity
     	* @param list real categories.
     	* @return string Ranking category.
     	*/
		public void printCatRating(list[real] categories){
		  if (categories[0] <=25.0 && categories[1] == 0.0 && categories[2] ==0.0){
		  	  		print(" / Rating: ++");
		  	  }
		  	  else if (categories[0] <=30.0 && categories[1] <=5.0 && categories[2] ==0.0){
		  	  		print(" / Rating: +");
		  	  }
		  	  else if (categories[0] <=40.0 && categories[1] <=10.0 && categories[2] ==0.0){
		  	  		print(" / Rating: o");
		  	  }
		  	  else if (categories[0] <= 50.0 && categories[1] <=15.0 && categories[2] <=5.0){
		  	  		print(" / Rating: -");
		  	  }
		  	  else{
		  	  		print(" / Rating: --");
		  	  }
		
		}
		

		