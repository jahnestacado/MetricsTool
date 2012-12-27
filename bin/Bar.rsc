module Bar
		
				
import IO;
import util::Math;
import vis::Figure;
import vis::Render;
				
int a1=0;
real a2=0.0;
str a3="";
int a4=0;
real add=0.0;
str theEnd="";
bool flag=false;
				
			
			public void drawHistogram(int pureLOC,int comments,int emptyLines){
			
				total=comments+emptyLines+pureLOC;
				commentsPerc=toReal(percent(comments,total))/100;
				locPerc=toReal(percent(pureLOC,total))/100;
				emptyLinesPerc=toReal(percent(emptyLines,total))/100;
				b1 = box(text("Total LOC: <total>"),hshrink(1.0),vshrink(0.2), fillColor("Blue"));
				b2 = box(text("Pure LOC: <pureLOC> (<locPerc>%)"),hshrink(locPerc),vshrink(0.2), fillColor("Yellow"));
				b3 = box(text("Commented Lines: <comments> (<commentsPerc>%)"),hshrink(commentsPerc),vshrink(0.2), fillColor("Green"));
				b4 = box(text("Empty Lines: <emptyLines> (<emptyLinesPerc>%)"),hshrink(emptyLinesPerc),vshrink(0.2), fillColor("Red"));
				render(vcat([b1, b2, b3, b4], std(left()),grow(1.1)));
			
			}
			
			
			
			public void bar(){
			
			
			add+=0.10;
			
			t1=ellipse(text(" LOC: <a1>",fontSize(9),fontColor("Black")),align(0.5, 0.5), size(100,100), fillColor("yellow"),std(vresizable(false)),std(hresizable(false)));
			t2=ellipse(text(" Dup: <a2>%",fontSize(9),fontColor("Black")),align(0.5, 0.5), size(100,100), fillColor("yellow"),std(vresizable(false)),std(hresizable(false)));
			t3= ellipse(text("       CC: <a3>",halign(0.5),fontSize(9),fontColor("Black")),align(0.5, 0.5), size(100,100), fillColor("yellow"),std(vresizable(false)),std(hresizable(false)));
			t4= ellipse(text(" USize: <a4>",fontSize(9),fontColor("Black")),align(0.5, 0.5), size(100,100), fillColor("yellow"),std(vresizable(false)),std(hresizable(false)));
			
			h =hcat(  [ ellipse(t1,align(0.0, 0.1), size(100,100), fillColor("black"),std(vresizable(false)),std(hresizable(false))),
					      ellipse(t2,align(0.0, 0.1), size(100,100), fillColor("black"),std(vresizable(false)),std(hresizable(false))),
					      ellipse(t3,align(0.0, 0.1), size(100,100), fillColor("black"),std(vresizable(false)),std(hresizable(false))),
					      ellipse(t4,align(0.0, 0.1), size(100,100), fillColor("black"),std(vresizable(false)),std(hresizable(false)))
					      ],
					      gap(10),vsize(200),std(vresizable(false))
				);
				
		
			if(add>0.9) theEnd="Analysis Complete";
		  	else theEnd="<toInt(add*100)>%";
			
			b2 = box(box(text("<theEnd>",fontColor("Black")),hshrink(add),vshrink(0.8),fillColor("yellow"),   left(), right()), vshrink(0.2),fillColor("Black"));
			render(vcat([h,b2], std(left()),bottom(),grow(0.9)));
	
	}
		
			
			
		public void update(int c1,real c2,str c3,int c4){
			if(a1==0)a1=c1;
			if(a2==0)a2=c2;
			if(a3=="")a3=c3;
			if(a4==0)a4=c4;
			bar();
		}
			
		
		
		
		
		
		