import flash.events.*;
import flash.net.URLLoader;  
import flash.ui.Mouse;
import flash.filesystem.*;
import flash.errors.IOError;

stop();
var defaultXML:XML=<QBANK>
  <alignment>
    <quesX>515.55</quesX>
    <quesY>170.05</quesY>
    <submitBtnX>798.3</submitBtnX>
    <submitBtnY>367.35</submitBtnY>
  </alignment>
  <settings>
    <noOfQues>4</noOfQues>
    <sound>false</sound>
    <dispInstantFeedback>true</dispInstantFeedback>
  </settings>
  <question id="1" type="MCQ">
    <statement>Select 5 ,6 , 8 . </statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>1</op>
      <op>6</op>
      <op>5</op>
	  <op>8</op>
    </options>
    <correct>8</correct>
    <correct>6</correct>
	<correct>5</correct>
  </question>
  <question id="2" type="MCQ">
    <statement>Numbers divisible by 3</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>6</op>
      <op>9</op>
    </options>
    <correct>6</correct>
    <correct>9</correct>
  </question>
  <question id="3" type="MCQ">
    <statement>x%5 = 0 , x = ?</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>15</op>
      <op>10</op>
      <op>20</op>
    </options>
    <correct>10</correct>
    <correct>15</correct>
    <correct>20</correct>
  </question>
  <question id="4" type="MCQ">
    <statement>4+10 = ?</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>15</op>
      <op>14</op>
      <op>20</op>
    </options>
    <correct>14</correct>
  </question>
  <question id="5" type="MCQ">
    <statement>Select 25 and 96</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>96</op>
      <op>25</op>
      <op>20</op>
    </options>
    <correct>25</correct>
    <correct>96</correct>
  </question>
  <question id="6" type="MCQ">
    <statement>50+10 = ?</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>15</op>
      <op>60</op>
      <op>20</op>
    </options>
    <correct>60</correct>
  </question>
  <question id="7" type="MCQ">
    <statement>5+100 = ?</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>150</op>
      <op>105</op>
      <op>200</op>
    </options>
    <correct>105</correct>
  </question>
  <question id="8" type="MCQ">
    <statement>6+3 = ?</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>9</op>
      <op>10</op>
      <op>20</op>
    </options>
    <correct>9</correct>
  </question>
  <question id="9" type="MCQ">
    <statement>10 + 10 = ?</statement>
    <mutipleSelect>false</mutipleSelect>
    <options>
      <op>15</op>
      <op>10</op>
      <op>20</op>
    </options>
    <correct>20</correct>
  </question>
  <question id="10" type="DND">
    <statement>Match with their countries.</statement>
    <mutipleSelect>true</mutipleSelect>
    <options>
      <op>INDIA</op>
      <op>USA</op>
      <op>AUSTRALIA</op>
    </options>
    <correct>DELHI</correct>
	<correct>WASHINGTON</correct>
	<correct>CANBERRA</correct>
  </question>
  <question id="11" type="DND">
    <statement>DROP AS SAID.</statement>
    <mutipleSelect>true</mutipleSelect>
    <options>
      <op>IN 2</op>
      <op>IN 3</op>
    </options>
    <correct>2</correct>
	<correct>3</correct>
  </question>
  
</QBANK>;

var retry_mode:Boolean=false;
var xml:XML = new XML();
var XML_URL1:String = "my_format.xml"; 
var XMLURL1:URLRequest = new URLRequest(XML_URL1); 
var Loader1:URLLoader = new URLLoader(XMLURL1); 
Loader1.addEventListener(Event.COMPLETE, xmlLoaded); 
Loader1.addEventListener(IOErrorEvent.IO_ERROR, errorhandler);

function xmlLoaded(event:Event):void 
{ 
    xml = XML(Loader1.data); 
    ParseXML(xml);
}


function errorhandler(e:IOErrorEvent):void{
        xml=defaultXML;
		//ParseXML(xml);
		Start.x=5000;
		
		//creating a new sample xml file if one does not exists already
		var fi:String = File.applicationDirectory.resolvePath('my_format.xml').nativePath;
		var f:File=new File(fi);
		//trace("===-> "+f.nativePath);
		var str:FileStream=new FileStream();
	    str.addEventListener(IOErrorEvent.IO_ERROR,errorHandler2);
		str.open(f, FileMode.WRITE);
		str.writeUTFBytes(String(xml));
		str.close();
		
		var inf_xml:info_box=new info_box();
	    inf_xml.info.text="A XML descriptor file was not found ,\n one has been created for you in the application directory \n please edit it before continuing";
		inf_xml.x=inf_x;
		inf_xml.y=inf_y;
		addChild(inf_xml);
		
		//trace("ERROR HAS OCCURED WHILE READING FROM FILE "+e.toString());
}

function errorHandler2(e:IOErrorEvent):void{
	
}


/*
< < <Question:Str> , <options:Str> , <correct:Str> , <response:Str> >
  < <Question> , <options> , <correct> , <response> > >
*/
//multiple select data is stord in first element of options vec 

var Data:Vector.<Object>;

//chosenAnswer to save state of current options *UNUSED CURRENTLY*
var chosenAnswer:Vector.<Object>=new Vector.<Object>();;

Data = new Vector.<Object>();
var totalQuestion:Number=Data.length;
var realQuestion: Array =new Array();


//default arguments
function initialize():void{
	currentQuestion=1;
	//realQuestion.sort( randomize ); will be done by randomSelect method called by parse XML class
	Data.splice(0,Data.length);
	chosenAnswer.splice(0,chosenAnswer.length);
	ParseXML(xml);
	
}

//realQuestion[nos]
//copied from SO
function randomize ( a : *, b : * ) : int {
    return ( Math.random() > .5 ) ? 1 : -1;
}

//returns random number in the range [xi,yi] inclusive 
function randRange(xi:Number,yi:Number){
	yi=yi+1;
    return int(Math.random()*(yi-xi)+xi)
}

function randomSelect(lims:Number){
	
	if(realQuestion.length==0){
	for(var g:Number=0;g<lims;g++){
		realQuestion.push(g);
	}
	}
	//trace(realQuestion);
	//realQuestion.sort( randomize );
	//trace(realQuestion);
	//fisher yates shuffle

	for (var jp:Number=lims-1;jp>=0;jp--){
	    var exchange:Number=randRange(0,jp);
	    var tmps:Number=realQuestion[exchange];
	    realQuestion[exchange]=realQuestion[0];
	    realQuestion[0]=tmps;
    }
	trace(realQuestion);
}

/*var x1:Vector.<String>;
x1 = new Vector.<String>();
x1.push("tp1");
x1.push("tp2");
v.push(x1);
trace(v[0][1]);


trace("SHOULD BE SHOWN");
//trace(xml.question[0].options.first);
var list:XMLList = xml.question[0].options;
trace(list.first);


for each(var property:XML in  xml.question[0].options){
	trace("here");
	trace(property);
	trace("bfdbfd");
}
*/

function ParseXML(inp:XML):void
{
    //trace(inp);
	//var  List1:XMLList  =  inp.question;
    var List1:XMLList = inp.question;
	trace(inp.alignment.option1);
	for each (var ques:XML in List1){
		
		var Question_obj:Vector.<Object>;
        Question_obj = new Vector.<Object>();
        
		//internal objs of Question_obj
		var stmt:Vector.<String>;
	    var options:Vector.<String>;
		var correct:Vector.<String>;
		var resp:Vector.<String>;
		var verdict:Vector.<Number>;
				
		stmt    = new Vector.<String>();
		options = new Vector.<String>();
		correct = new Vector.<String>();
		resp    = new Vector.<String>();
		verdict = new Vector.<Number>();
		
		verdict.push(0);
		trace(">>");
		trace(ques.attribute("type"));
		stmt.push(ques.statement);
		if(ques.mutipleSelect=="true" && ques.attribute("type")=="MCQ")
		    options.push("1");
		else
		    if(ques.attribute("type")=="MCQ")
		    	options.push("0");
			else
				options.push("2");
		
		for each (var optns:XML in ques.options.op){
			options.push(optns);
		}
		
		for each (var corr:XML in ques.correct){
			correct.push(corr);
		}
		
		Question_obj.push(stmt);
		Question_obj.push(options);
		Question_obj.push(correct);
		Question_obj.push(resp);
		Question_obj.push(verdict)
		Data.push(Question_obj);
    }
	
	//XML PROPERTY DATA SUCH AS SUBMIT BTN POS etc GETS LOADED HERE
	
	totalQuestion=Data.length;
	randomSelect(totalQuestion);
	//trace("===> "+inp.settings.noOfQues);
	totalQuestion=Number(inp.settings.noOfQues);
	ques_x       =Number(inp.alignment.quesX);
    ques_y       =Number(inp.alignment.quesY);
	sub_btn_x    =Number(inp.alignment.submitBtnX);
    sub_btn_y    =Number(inp.alignment.submitBtnY);
    if(String(inp.settings.dispInstantFeedback)=="false"){
	    showInstFeedback=false;
		//trace("showInstFeedback FALSE");
	}
     
	//trace("===> "+Data);
}


//trace(Data[0][1].length);


// one indexed but actual arrat is not
var currentQuestion:Number=1;
var currentOptions:Number=0;
var ques:question_box=new question_box();
var option1:option_box=new option_box();
var option2:option_box=new option_box();
var option3:option_box=new option_box();
var option4:option_box=new option_box();
var Start:submit_btn  =new submit_btn();
var Next:submit_btn   =new submit_btn();
var back:submit_btn  = new submit_btn();
var feedback_box:feedback = new feedback();


Start.info.text="START";
back.info.text="BACK";
//taking them off stage
option1.x=2000;
option2.x=2000;
option3.x=2000;
option4.x=2000;
ques.x=2000;
Start.x=550;
Start.y=300;
Next.x=2000;
Next.y=sub_btn_y;
back.x=back_btn_x;
back.y=2000;
feedback_box.x=2000;
feedback_box.y=feed_y;
//ques.x=ques_x;
//ques.y=ques_y;
//trace("ount "+Data[2][1].length);
addChild(ques);
stage.addChild(Start);
addChild(back);
addChild(option1);
addChild(option2);
addChild(option3);
addChild(option4);
addChild(feedback_box);

//
//options positioning and display
function options_correction(nos:Number){
	nos=nos-1;
	currentOptions=Data[realQuestion[nos]][1].length-1;
	
	//for randomized arrangement of options
	var optionArr: Array =[op1_y,op2_y,op3_y,op4_y];
	//trace(optionArr);
	
	//to remove those options which are not needed 
	for(var gx:Number=currentOptions;gx<4;gx++){
		optionArr.pop();
	}
	optionArr.sort( randomize );
	if(currentOptions>0){
		option1.x=op1_x;
		option1.y=optionArr[0];
		//trace(Data[nos][1][1]);
		//option1.info1.text="gbfb";
		option1.info1.text=Data[realQuestion[nos]][1][1];
	}
	if(currentOptions>1){
		option2.x=op2_x;
		option2.y=optionArr[1];
		option2.info1.text=Data[realQuestion[nos]][1][2];
	}
	if(currentOptions>2){
		option3.x=op3_x;
		option3.y=optionArr[2];
		option3.info1.text=Data[realQuestion[nos]][1][3];
	}
	if(currentOptions>3){
		option4.x=op4_x;
		option4.y=optionArr[3];
		option4.info1.text=Data[realQuestion[nos]][1][4];
	}
}

function options_correction_forDND(nos:Number){

	nos=nos-1;
	var availOpns:Number=Data[realQuestion[nos]][1].length-1;
	initializePos(availOpns,1);
	ShowHideDND(availOpns,1);
	for(var xi:int=0;xi<availOpns;xi++){
		dropper[xi].info.text=Data[realQuestion[nos]][1][xi+1];
		bucket[xi].info.text=Data[realQuestion[nos]][2][xi];
	}
}

//options_correction(3);
function displayOptions(nos:Number){
	option1.x=2000;
	option2.x=2000;
	option3.x=2000;
	option4.x=2000;
	option1.gotoAndStop(0);
	option2.gotoAndStop(0);
	option3.gotoAndStop(0);
	option4.gotoAndStop(0);
	//trace(">>>> "+Data[realQuestion[currentQuestion-1]][1][1]);
	if(Data[realQuestion[currentQuestion-1]][1][0]!=2){
		options_correction(currentQuestion);
	}
	else{
		//for DND questionare 
		options_correction_forDND(currentQuestion);
		reset.addEventListener(MouseEvent.CLICK,reset_DND);
	}
}

function reset_DND(event:MouseEvent):void{
	displayOptions(currentQuestion);
}

Start.addEventListener(MouseEvent.CLICK, startquiz);
back.addEventListener(MouseEvent.CLICK,back_);

function back_(event:MouseEvent):void{
	
	
	ShowHideDND(3,0);
	if(currentQuestion>0)
	    currentQuestion--;
	var len=Data[realQuestion[currentQuestion-1]][3].length;
	for(var elem:Number=0;elem<len;elem++)
	   Data[realQuestion[currentQuestion-1]][3].pop();
	//trace("Current size after rollback for 3rd "+ Data[realQuestion[currentQuestion-1]][3].length);
	displayQues(currentQuestion);
}

stage.addChild(Next);

function startquiz(event:MouseEvent):void{
	
	Start.x=5000;
	//trace("Request "+Data[1][1]);
	currentQuestion=1;
	
	Next.x=sub_btn_x;
	Next.info.text="NEXT";
	Next.addEventListener(MouseEvent.CLICK,submit_n_nextques);
	displayQues(currentQuestion);
}

//for the final answer
function feedback_msg(ques_no:Number):String{
	ShowHideDND(3,0);
	
	if(Data[realQuestion[ques_no]][1][0]==2){
		return feedback_msg_DND(ques_no);
	}
	
	var correct_ans:String="Corrrect Answer Is ";
	var result1:String
	for(var c:Number=0;c<Data[realQuestion[ques_no]][2].length;c++){
		correct_ans+=Data[realQuestion[ques_no]][2][c];
		if(c+1<Data[realQuestion[ques_no]][2].length)
		  correct_ans+=" And ";
		 else
		  correct_ans+=".";
	}
	if(Data[realQuestion[ques_no]][2].length!=Data[realQuestion[ques_no]][3].length){
		result1="Wrong Answer , "+correct_ans;
		Data[realQuestion[ques_no]][4][0]=0;
	}
	else{
		var cor:Number=1;
		var found=0;
			for(var cx:int=0 ;cx < Data[realQuestion[ques_no]][2].length;cx++){
				
				for(var dx:int=0 ; dx< Data[realQuestion[ques_no]][2].length ; dx++){
					if(Data[realQuestion[ques_no]][2][cx]==Data[realQuestion[ques_no]][3][dx]){
					    found++;
				    }
				}
			}
			//trace("found "+found);
			if(found==Data[realQuestion[ques_no]][2].length)
			    cor=1;
			else 
			    cor=0;
			
			if(cor==0){
		    	result1="Wrong Answer , "+correct_ans;
			    Data[realQuestion[ques_no]][4][0]=0;
			}
			else{
		    	result1="Correct Answer ";
			    Data[realQuestion[ques_no]][4][0]=1;
			}
	}
	//trace("==>>> "+Data[realQuestion[ques_no]]);
	return result1;
}

function feedback_msg_DND(ques_no:Number):String{
	if(judge_DND(ques_no))
	    return "Correct Answer";
	else
	    return "Wrong Answer";
}

function judge_DND(ques_no){
	var availOpns:Number=Data[realQuestion[ques_no]][1].length-1;
	var decision:Boolean=true;
	Data[realQuestion[ques_no]][4][0]=1;
	for(var xi:Number=1;xi<=availOpns;xi++){
		if(Data[realQuestion[ques_no]][2][xi-1]!=Data[realQuestion[ques_no]][3][xi-1]){
		    decision=false;
			Data[realQuestion[ques_no]][4][0]=0;
		}
	}
	return decision;
}

function submit_n_nextques(event:MouseEvent):void{
	var nos:Number=currentQuestion-1;
	
	//TO CLEAR VEC[...][RESPONSE] BEFORE COMPUTATION
	        var elems=Data[realQuestion[nos]][3].length;
			//trace("SIZE "+elems);
			while(Data[realQuestion[nos]][3].length>0){
				Data[realQuestion[nos]][3].pop();
			}
	currentOptions=Data[realQuestion[nos]][1].length-1;
	
	if(Data[realQuestion[currentQuestion-1]][1][0]==2){
		if(currentOptions>0){
			Data[realQuestion[nos]][3].push(dropper[1-1].ans);
		}
		if(currentOptions>1){
			Data[realQuestion[nos]][3].push(dropper[2-1].ans);
		}
		if(currentOptions>2){
			Data[realQuestion[nos]][3].push(dropper[3-1].ans);
		}
	}
	else{
	//current options to save state of the selected options **currently unused**
		var current:Vector.<Number>=new Vector.<Number>();;
	
		if(currentOptions>0&&option1.info==1){
		Data[realQuestion[nos]][3].push(Data[realQuestion[nos]][1][1]);
		current.push(1);
		}
		if(currentOptions>1&&option2.info==1){
		Data[realQuestion[nos]][3].push(Data[realQuestion[nos]][1][2]);
		current.push(2);
		}
		if(currentOptions>2&&option3.info==1){
		Data[realQuestion[nos]][3].push(Data[realQuestion[nos]][1][3]);
		current.push(3);
		}
		if(currentOptions>3&&option4.info==1){
		Data[realQuestion[nos]][3].push(Data[realQuestion[nos]][1][4]);
		current.push(4);
		}
	}
	//trace(Data[realQuestion[nos]][3]+"   "+Data[realQuestion[nos]][2]);
	if(showInstFeedback){
		
		initializePos(3,1);
		feedback_box.x=feed_x;
		feedback_box.y=feed_y;
		feedback_box.width=1050;
		feedback_box.height=130;
		trace("INP ANS : "+Data[realQuestion[nos]][3]);
		trace("CORRECT ANS : "+Data[realQuestion[nos]][2]);
		feedback_box.info=feedback_msg(currentQuestion-1);
		feedback_box.gotoAndPlay(5);
	}
	currentQuestion+=1;
	
	displayQues(currentQuestion);
}

function displayQues(nos:Number):void{
	nos=nos-1;
	if(nos>0)
	    back.y=back_btn_y;
	else
	    back.y=2000;
	if(currentQuestion==totalQuestion)
	    Next.info.text="SUBMIT";
	if(currentQuestion>totalQuestion){
		Next.x=2000;
		option1.x=2000;
	    option2.x=2000;
	    option3.x=2000;
	    option4.x=2000;
		ques.x=2000;
		back.y=2000;
		displayResult();
	}
	else{
		if(Data[realQuestion[nos]][4][0]==1&&retry_mode){
			currentQuestion+=1;
			nos+=1
			displayQues(currentQuestion);
			return;
		}
		ques.info.text=Data[realQuestion[nos]][0][0];
		ques.x=ques_x;
		ques.y=ques_y;
		displayOptions(nos+1);
	}
}

var closeApp:submit_btn=new submit_btn();
var retry:submit_btn=new submit_btn();
var inf_disp:info_box=new info_box();
var new_test:submit_btn=new submit_btn();

function displayResult():void{
	
	var correct:Number=0;
	//trace("here" + totalQuestion);
	for (var ci:int = 0; ci < totalQuestion ; ci++){
		var judge:Number=0;
		trace("CORRECT ANS  "+ Data[realQuestion[ci]][2]);
		trace("Selected ANS "+ Data[realQuestion[ci]][3]);
	    if(Data[realQuestion[ci]][2].length==Data[realQuestion[ci]][3].length){
			judge=1;
			var found=0;
			for(var cx:int=0 ;cx < Data[realQuestion[ci]][2].length;cx++){
				for(var dx:int=0 ; dx< Data[realQuestion[ci]][2].length ; dx++){
					if(Data[realQuestion[ci]][2][cx]==Data[realQuestion[ci]][3][dx]){
					    found++;
				    }
				}
			}
			//trace("found "+found);
			if(found==Data[realQuestion[ci]][2].length)
			    judge=1;
			else 
			    judge=0;
			
		}
		
		//trace("judge ==== ==== "+judge);
		if(judge==1)
		    correct++;
		else
		    if(Data[realQuestion[ci]][1][0]==2&&judge_DND(ci)){
				correct++;
				judge=1;
			}
	}
	inf_disp.info.text="You Scored "+correct+" Out of "+totalQuestion+"\n THANKS ";
	inf_disp.x=inf_x;
	inf_disp.y=inf_y;
	if(totalQuestion!=0)
	stage.addChild(inf_disp);
	
	//retry and close button 
	
	closeApp.info.text="CLOSE";
	retry.info.text="RETRY";
	new_test.info.text="NEW TEST";
	closeApp.addEventListener(MouseEvent.CLICK,closeApplication);
	retry.addEventListener(MouseEvent.CLICK,retry_questionaire);
	new_test.addEventListener(MouseEvent.CLICK,newTest);
	closeApp.x=500;
	closeApp.y=458-80;
	retry.x=closeApp.x-165;
	retry.y=closeApp.y+100;
	new_test.x=closeApp.x+165;
	new_test.y=closeApp.y+100;
	
	stage.addChild(closeApp);
	stage.addChild(new_test);
	stage.addChild(retry);
	
	//trace("correct = "+correct);
}

function remResultScrElm():void{
	stage.removeChild(closeApp);
	stage.removeChild(new_test);
	stage.removeChild(retry);
	stage.removeChild(inf_disp);
}

function retry_questionaire(event:MouseEvent):void{
    
	remResultScrElm();
	currentQuestion=1;
	retry_mode=true;
	startquiz(event);
	
}

closeIt.addEventListener(MouseEvent.CLICK,closeApplication);

function closeApplication(event:MouseEvent):void{
    NativeApplication.nativeApplication.exit();
}

function newTest(event:MouseEvent):void{
	
	remResultScrElm();
	initialize();
	startquiz(event);
	
}

frame.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);

function moveWindow(e:Event):void
{
	stage.nativeWindow.startMove();
}
