use v6;
unit module Tokenize;

# Parse the input into a list of tokens
#  Input - $data is a string representing a program
#  Output - A list of tokens 
sub getTokens ($data) is export {
  # Recursively adds values from $text into token list
  # Returns an array of tokens
  sub generateTokens($text, @resultsList) {
    my $newString = "";
    if substr($text, 0..0) ~~ m/ "#" / {
      if $text ~~ m/ "\n" / {
        @resultsList.push("COMMENT: " ~ $/.prematch);
        $newString = $/.postmatch;
      }
      else {
        @resultsList.push("COMMENT: " ~ $text);
        $newString = "";
      }
    }
    elsif substr($text, 0..0) ~~ m/(<:L>) / {
      if $text ~~ m/ (<:!L>) / {
        @resultsList.push("KEYWORD: " ~ $/.prematch);
        $newString = $/ ~ $/.postmatch;
      }
    }
    elsif substr($text, 0..0) ~~ m/ "\$" / {
      #say substr($text, 0..0);
      if substr($text, 1..$text.chars) ~~ m/ (<:!L>) / {
        #say $/;
        @resultsList.push("VAR: " ~ "\$" ~ $/.prematch);
        $newString = $/ ~ $/.postmatch;
      }
    }
    elsif substr($text, 0..0) ~~ m/ "=" / {
      @resultsList.push("ASSIGNOP: " ~ "=");
      $newString = substr($text, 1..$text.chars);
    }
    elsif substr($text, 0..0) ~~ m/ "+"|"-"|"*"|"/" / {
      @resultsList.push("MATHOP: " ~ substr($text, 0..0));
      $newString = substr($text, 1..$text.chars);
    }
    elsif substr($text, 0..0) ~~ m/(<:N>) / {
      if $text ~~ m/ (<:!N>) / {
        @resultsList.push("INTEGER: " ~ $/.prematch);
        $newString = $/ ~ $/.postmatch;
      }
    } 
    elsif substr($text, 0..0) ~~ m/ ";" / {
      @resultsList.push("EOS: " ~ ";");
      $newString = substr($text, 1..$text.chars);
    }
    elsif substr($text, 0..0) ~~ m/ "(" / {
      @resultsList.push("LPAREN: " ~ "(");
      $newString = substr($text, 1..$text.chars);
    }      
    elsif substr($text, 0..0) ~~ m/ "<"|">" / {
      @resultsList.push("COMPOP: " ~ substr($text, 0..0));
      $newString = substr($text, 1..$text.chars);
    }       
    if substr($text, 0..0) ~~ m/ "\"" / {
      if substr($text, 1..$text.chars) ~~ m/ "\"" / {
        @resultsList.push("STRING: " ~ $/ ~ $/.prematch ~ $/);
        $newString = $/.postmatch;
      }
    }
    elsif substr($text, 0..0) ~~ m/ ")" / {
      @resultsList.push("RPAREN: " ~ ")");
      $newString = substr($text, 1..$text.chars);
    } 
    elsif substr($text, 0..0) ~~ m/ "\{" / {
      @resultsList.push("LBRACE: " ~ "\{");
      $newString = substr($text, 1..$text.chars);
    } 
    elsif substr($text, 0..0) ~~ m/ "\}" / {
      @resultsList.push("RBRACE: " ~ "\}");
      $newString = substr($text, 1..$text.chars);
    }     
  
    #Recursion ends when $text is empty
    if $newString.chars > 0 {
    return generateTokens($newString, @resultsList);
    }
    else {
      return @resultsList;
    }
  }

  my @results = "";
  
  my @newData = generateTokens($data, @results);

  return @newData;
}
