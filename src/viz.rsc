module viz

import lang::java::jdt::Java;
import lang::java::jdt::JDT;
import lang::java::jdt::JavaADT;
import util::Math;
import IO;
import Set;
import String;
import List;
import Relation;
import CC_UnitSize;
import LOC;
import Clones;
import vis::Render;
import vis::Figure;
import vis::KeySym;
import vis::Chart;
import Main;
import util::IDE;
import util::Editors;

public list[int] stackprev = [];
public list[str] stackname = [];
public list[loc] stacklock = [];
public list[int] stackwidth = [];
list[str]  colorList=[];
Figure  t1 = text("Legend", fontSize(15),size(40,10), fontColor("black"),resizable(false),center());
Figure	b1 = box(text("cc\<=10"),size(100,10), fillColor("Green"),center(),resizable(false));
Figure  b2 = box( text("cc\<=20"),fillColor("Yellow"),resizable(false),size(100,10),center());
Figure	b3 = box( text("cc\<=50"),fillColor("Orange"),resizable(false),center(),size(100,10));
Figure	b4 = box( text("cc\>50"),fillColor("Red"),resizable(false),center(),size(100,10));
Figure  i1 = text("Info", fontSize(15),size(40,10), fontColor("black"),resizable(false),center());
Figure  i4 = text("CC", fontSize(15),size(40,10), fontColor("black"),resizable(false),center());



public void dupoutline (int totalSize, list[int] pos, list[int] siz)
{
	lineInfo =[];
	lineInfo = [highlight(pos[i], "a",siz[i])|int i <-[0..size(pos)-1]];
	k = outline(lineInfo, totalSize, size(40,totalSize/10),fillColor("Black"));
	backbutton = box(text("Back",fontSize(10)),grow(2),bottom(),resizable(false),returntoMain(stackprev,stackname,stacklock,stackwidth),fillColor("lightGrey"));
	
	render(vcat([k, backbutton],gap(10),resizable(false),center()));
}

public void getPreview(list[int] prev, list[str] name, list[loc] loclist, list[int] widthh){
		listSize=size(name);
		stackprev = prev;
		stackname = name;
		stacklock = loclist;
		stackwidth = widthh;
		setColors();
		totar = getTotalLoc();
		totar1 = getTotalDup();
		totar2 = getCCOveral();
		totar3 = getTotUnSize();
		i2 =  text("Total Loc: <totar>",resizable(false),center(),size(100,10));
		i3 =  text("Duplication: <totar1>%",resizable(false),center(),size(100,10));
		i8 =  text("Total Unit Size: <totar3>",resizable(false),center(),size(100,10));
		i5 =  text("Moderate: <totar2[0]>%",resizable(false),center(),size(100,10));
		i6 =  text("High: <totar2[1]>%",resizable(false),center(),size(100,10));
		i7 =  text("Very High: <totar2[2]>%",resizable(false),center(),size(100,10));
		list[tuple[int first,str last, loc fileloc,str color, int widt]] T =[<prev[i], name[i], loclist[i],colorList[i], widthh[i]> | int i <- [0 .. listSize-1]];
		boxes = [ box([size(x.widt/2,x.first/2),resizable(false),center(),fillColor(x.color),popup(x.last, x.first, x.widt),open(x.fileloc)]) |  x<-T];
		classPack=pack(boxes,[size(300,300),vgap(10),hgap(20),hshrink(0.8),center()]);
		tt=vcat([t1,b1,b2,b3,b4,i1,i2,i8,i3,i4,i5,i6,i7], std(right()),top(),resizable(false));
		legbox = hcat([classPack,tt],gap(10),left());
        dubBut1 = box(text("Duplication 1",fontSize(10)),size(80,10),top(),resizable(false),showDup(0),fillColor("lightGrey"),left());
        dubBut2 = box(text("Duplication 2",fontSize(10)),size(80,10),top(),resizable(false),showDup(1),fillColor("lightGrey"),left());
      	ee=hcat([dubBut1,dubBut2],std(hgap(10)),left(),hresizable(false),fillColor("Red"));
		render(vcat([legbox,ee],gap(3)));
}

public FProperty popup(str s,int k, int j){
	    return mouseOver(box(text("Filename:<s>\n" + "LOC:<k>\n" + "Methods:<j>",font("Impact")),size(10,10),right(),grow(1.1),fillColor("moccasin"),resizable(false)));

}
 
public FProperty popup3(str s,int k){
	    return mouseOver(box(text("Methodname:<s>\n"+"Unit Size:<k>\n",font("Impact")),size(10,10),right(),fillColor("moccasin"),grow(1.1),resizable(false)));

} 

public FProperty open(loc fileloc)
{ 
 	    return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
     
        Ctree(fileloc);
        return true;
        });
}


public void setColors(){
        temp=getCcColor();
		for(int i<-[0..size(temp)-1]){
				colorList+=checkCC(temp[i]);
		
		}
}


public void Ctree(loc paths){

	    setComlexityOfUnits([paths]);
		list[value] boxes = [];
		list[int] lista = getUnitSizeList();
		list[int] lista2 = getCCofUnit();
		list[str] lista3 = getmethodName();
		list[loc] uriList=getUriList();
		list[tuple[int unit,int cc, str name,loc path]] T =[<lista[i], lista2[i],lista3[i],uriList[i]> | int i <- [0 .. size(lista)-1]];
		i = hcat([box(project(text("<s.cc>",fontSize(15),fontColor(checkCC(s.cc))),"Bar"),shadow(true),size(30,s.unit*3),popup3(s.name,s.unit),openEditor(s.path),vresizable(false),fillColor(checkCC(s.cc)),bottom()) | s <- T],top(),gap(5));
	    sc = hscreen(i,id("Bar"),vgap(10),vshrink(0.7),left());
		backbutton = box(text("Back",fontSize(10)),grow(2),bottom(),center(),resizable(false),left(),returntoMain(stackprev,stackname,stacklock,stackwidth),fillColor("lightGrey"));
	    legend=vcat([t1,b1,b2,b3,b4], std(right()),resizable(false));
		render(vcat([legend,sc,backbutton],gap(3),resizable(false),left(),shrink(0.5)));
}

public FProperty openEditor(loc path)
{ 
 	    return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
   		edit(path);
        return true;
        });
}

public FProperty dupHover(str s){
	  	 int x=0;
	     if(s==""){ x=0;}
	     else x=10;
	     s=replaceAll(s,";",";\n");
		 return mouseOver(box(text(s),shrink(0.5),bottom(),fillColor("Yellow"),resizable(true)));

}

public FProperty returntoMain(list[int] stackprev, list[str] stackname, list[loc] stackloclist, list[int] stackwidth)
{
	k = stackprev;
	i = stackname;
	j = stacklock;
	z = stackwidth;
    return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
    getPreview(k,i,j,z);
    return true;
  });
}

public FProperty showDup(int i){
	 	return onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
 		if(i==0)dupoutline (getLoc(),clonePosition(),cloneSize());  //Outline
 		else newDup();
    	return true;
  });
}


public void newDup(){
	listProject=getAll7Lines();
	clones=getClones();
	flag=false;
	clonesTemp=clones;
	lista=[];

	for(int i<-[0..size(listProject)-1]){
		if(listProject[i] in clonesTemp){
			clonesTemp=clonesTemp-listProject[i];
			lista+="Yellow";
		}
		else if(listProject[i] in clones){
			lista+="Red";
		}
		else lista+="Green";
	}

	for(int i<-[0..size(lista)-1]){
		if(lista[i]=="Green") listProject[i]="";
	}

	list[tuple[str text,str color]] T =[<listProject[i], lista[i]> | int i <- [0 .. size(lista)-1]];
	boxes = [ box([size(5,5), fillColor(c.color),dupHover(c.text)]) | c <- T];
	i=hvcat(boxes, width(500), left(),vresizable(true));
    sc = hscreen(i,id("Bar"),vgap(10),vshrink(0.7),left());
	backbutton = box(text("Back",fontSize(10)),grow(2),bottom(),center(),resizable(false),left(),returntoMain(stackprev,stackname,stacklock,stackwidth),fillColor("lightGrey"));
	render(vcat([sc,backbutton],gap(3),resizable(true),left()));
}

public str checkCC(int cc){
	if( cc <= 10 )  return "Green";
	else if( cc <= 20 ) return "Yellow";
	else if( cc <= 50 ) return "Orange";
	else  return "Red";
}