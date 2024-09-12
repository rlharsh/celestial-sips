choice_variable = -1;

interact_key = ord("E");
detection_radius = 32;

myVoice			= snd_voice1;
myPortrait		= -1;
myFont			= fnt_dialogue;
myName			= "Unknown";

myPortraitTalk		= -1;
myPortraitTalk_x	= -1;
myPortraitTalk_y	= -1;
myPortraitIdle		= -1;
myPortraitIdle_x	= -1;
myPortraitIdle_y	= -1;


//-----------Defaults Setup (LEAVE THIS STUFF)
reset_dialogue_defaults();

		var i = 0;
		myText[i]		= "Hello, are you okay? That was quite a fall you just had.";


		i++;
		myText[i]		= "Do you remember your name?";

		
		i++;
		myText[i] =		["I think so", "No, where am I?"];
		myTypes[i] = 1;
		myNextLine[i] = [3, 4];

		
		i++;
		myText[i] =		"I'm glad you remember your name";
		myNextLine[i] = 5;

		
		i++;
		myText[i] =		"Well, why don't you tell me what you think is your name then?";

		i++;
		myText[i] =		"Okay, let's get you back on your feet."
		
		

create_dialogue(myText, mySpeaker, myEffects, myTextSpeed, myTypes, myNextLine, myScripts, myTextCol, myEmotion, myEmote);