use v6;
unit module MyCode;

sub getTokens ($program) is export {
  sub makeTokens($text, @Lst){
    my $String ="";
    #checks for letters
    if substr($text, 0..0) ~~ m/(<:L>) / {
      if $text ~~ m/ (<:!L>) / {
        @Lst.push("IDENTIFER: " ~ $/.prematch );
        $String = $/ ~ $/.postmatch;
      }
    }
    #checks for the eqaul sign
    elsif substr($text, 0) ~~ m/ "=" / {
      @Lst.push("EQUAL: " ~ "=");
      $String = substr($text, 1..$text.chars);
    }
    #checks for comments
    elsif substr($text, 0) ~~ m/ "#" / {
      @Lst.push("COMMENT: " ~ "#");
      $String = substr($text, 1..$text.chars);
    }
    #checks for addition
    elsif substr($text, 0..0) ~~ m/ "+" / {
      @Lst.push("ADDITION: " ~ "+");
      $String = substr($text, 1..$text.chars);
    }
    #checks for subtraction
    elsif substr($text, 0..0) ~~ m/ "-" / {
      @Lst.push("SUBTRACTION: " ~ "-");
      $String = substr($text, 1..$text.chars);
    }
    #check for multiplaction
    elsif substr($text, 0..0) ~~ m/ "*" / { 
      @Lst.push("MULTIPLICATION: " ~ "*");
      $String = substr($text, 1..$text.chars);
    }
    #checks for divison
    elsif substr($text, 0..0) ~~ m/ "/" / { 
      @Lst.push("DIVSION: " ~ "/");
      $String = substr($text, 1..$text.chars);
    }
    #checks for a number
    elsif substr($text, 0..0) ~~ m/(<:N>) / {
      if $text ~~ m/ (<:!N>) / {
        @Lst.push("INTEGER: " ~ $/.prematch);
        $String = $/ ~ $/.postmatch;
      }
    }
    #checks for parthenses
    elsif substr($text, 0..0) ~~ m/ "(" / {
      @Lst.push("LPAREN: " ~ "(");
      $String = substr($text, 1..$text.chars);
    }
    elsif substr($text, 0..0) ~~ m/ ")" / {
      @Lst.push("RPAREN: " ~ ")");
      $String = substr($text, 1..$text.chars);
    }
    #checks for comments
    elsif substr($text, 0..0) ~~ m/ ";" / {
      if $text ~~ m/ "\n" / {
        @Lst.push("COMMENT: " ~ $/.prematch);
        $String = $/.postmatch;
      }
      else {
        @Lst.push("COMMENT: " ~ $text);
        $String = "";
      }
    }
    elsif substr($text, 0..0) ~~ m/ "#" / {
      if $text ~~ m/ "\n" / {
        @Lst.push("COMMENT: " ~ $/.prematch);
        $String = $/.postmatch;
      }
      else {
        @Lst.push("COMMENT: " ~ $text);
        $String = "";
      }
    }
    #checks for whitespace
    elsif substr($text, 0..0) ~~ m/ " " / {
      $String = substr($text, 1..$text.chars);
    }
    elsif substr($text, 0..0) ~~ m/ "\n" / {
      $String = substr($text, 1..$text.chars);    
    }
    
    if $String.chars > 0 {
      return makeTokens($String, @Lst);
    } 
    else {
      return @Lst;
    }
  }
  my @results = "";
  my @newData = makeTokens($program, @results);

  return @newData;
}
sub balance (@tokens) is export {
   #varible to be counter
   my $lst = 0;
   my $bool = False;
  #checks the whole lst to get number 
   for @tokens.comb -> $element {
     if $element eq "(" {
        $lst = $lst + 1;
     }
     elsif $element eq ")" {
       --$lst;
	    }
      else {
      }
  }
  #returns based on nummber
  if $lst == 0 {
	     $bool = True;
  }
  else{
    $bool = False;
  }
}


sub format (@tokens) is export {
  # indent level
  my $tab = 0;
  my $first = True;
  my $lastParen = False;
  my $return = "";
  for @tokens -> $element {
    #calls my spilt function
    my $elementTok = getTokChar($element);
    my $firstchar = substr($elementTok,0);
    my $decreLine = False;
    my $indentNext = False;
    my $newLine = True;
    my $next = "";
    #checks the firstchar to change indents
    given $firstchar {
      when "(" {
        $next = "(";
        $indentNext = True;
      }
      when "#" {
        $next = substr($elementTok, 0, *-2);
      }
      when ";" {
          $next = substr($elementTok, 0, *-2);
      }
      when ")" {
        $next = ")";
        $decreLine = True;
      }
      default {
        if !$first and !$lastParen {
          $next = " ";
        }
        $next = $next ~ $elementTok;
      }
    }
    #change tab level
    if $decreLine {
      $tab = $tab -4;
      if $tab <0 {
        $tab =0;
      }
    }
    #sets up the tabs
    if $first {
      my $indent ="";
      for 1..$tab {
        $indent = $indent ~ " ";
      }
      $return = $return ~ $indent;
    }
    $first = $newLine;
    #new line
    if $newLine {
      $next = $next ~ "\n";
    }
    #change tab level
    if $indentNext {
      $tab = $tab + 4;
    }
    $lastParen = $firstchar eq "(";
    $return = $return ~ $next;
  }
  return $return;
}
sub getTokChar($data) is export {
  #splits the line
  my @dataSplit = split(/\: /, $data, :skip-empty, :v);
  my $return = "";
  my $Colon = False;
#checks for the colon
  for @dataSplit -> $element {
    if $Colon == True {
      $return = $return ~ $element;
    }
    elsif $element eq ":" {
      $Colon = True;
    }
    else { }
  }
  return trim($return);
}