require "pry"

#### method to translate word letter-casing properly ##############
def caseify(word)
  if word =~ /[A-Z]/
    word.downcase!
    word.capitalize!
  end
  word
end

#### method to handle joining the word array together properly with correct punctuation placement ##############
def sentenceify(arr)

  open_brackets = ["(", "[", "{"]
  close_brackets = [")", "]", "}"]
  word_ending_chars = [".", ",", ";", "!", "?"]

  i = 0
  while i < arr.length
    if open_brackets.include?(arr[i][0])
      arr[i] += arr[i+1]
      arr.delete_at(i+1)
    elsif close_brackets.include?(arr[i][0])
      arr[i-1] += arr[i]
      arr.delete_at(i)
    elsif word_ending_chars.include?(arr[i][0])
      arr[i-1] += arr[i]
      arr.delete_at(i)
    end
    i += 1    
  end

  return arr.join(' ')
end

#### individual word translator ##############
def translate_individual_word(word)
  vowels = ["a", "e", "i", "o", "u"]

  if word.include?("-") && word.length > 1 # if it's a hyphenated word
    new_str = ""
    arr = word.split(/[-]+/)
    arr.insert(1,"-")
    arr.each do |str|
      new_str += caseify(translate_individual_word(str))
    end
    return new_str
  elsif (word =~ /\d/) && (word.scan(/\D/).count != 0) # if it contains a number (like 3rd)
    return word + "ay"
  elsif (word =~ /\d/) && (word.scan(/\D/).count == 0) # if it's just a number
    return word
  elsif vowels.include? word[0].downcase # if first char is a vowel
    pig_latin_word = word + "way"
    return caseify(pig_latin_word)
  elsif (word.scan(/[aeiou]/).count == 0) && (word[-1] == "y") # for most zero-vowel words ending in 'y'
    word.slice!(-1)
    pig_latin_word = "y" + word + "ay"
    return caseify(pig_latin_word)
  elsif (word.scan(/[aeiou]/).count == 0) && (word[-1] != "y") && (word[0] =~ /[[:alpha:]]/) # zero-vowel words that don't end in 'y'
    i = 0
    consonants = ""
    until word[0].downcase == "y"
      consonants << word.slice!(word[0])
      pig_latin_word = word + consonants
      i += 1
    end
    pig_latin_word += "ay"  
    return caseify(pig_latin_word)
  elsif word[0] =~ /[[:alpha:]]/ # if first char is a letter (and non-vowel, per above)
    i = 0
    consonants = ""
    until vowels.include? word[0]
      consonants << word.slice!(word[0])
      pig_latin_word = word + consonants
      i += 1
    end
    pig_latin_word += "ay"  
    return caseify(pig_latin_word)
  else # if char is not a letter
    return word
  end
end


#### full input translator ##############
def translate_full_input(input)
  # split input at each line break
  input_arr = input.split(/\n+/)
  # go through each line, translating word by word
  # shovel each translated line into the final array
  final_arr = []
  input_arr.each do |line|
    words = line.scan(/[\w'-]+|[[:punct:]]+/)
    words.map! do |word| 
      translate_individual_word(word)
    end
    final_arr << sentenceify(words)
  end

  # Remove the "*END*" string
  final_arr.last.slice! "* Endway *"

  # Print line by line
  final_arr.each do |line|
    puts line
  end

end

#### DRIVER CODE ##############
puts "Please paste the text to translate below. After pasting, type '*END*' (case sensitive) to end your input."

# program to fetch multi-line input from the user
# user can type "*END*" to end the input
$/ = "*END*"
input = STDIN.gets

# print ellipses to simulate computer processing
# bc I'm a nerd
dots = [".",".","."," "]
3.times do 
  dots.each {|i| print i; sleep 0.20}
end

puts "\n\nHere's your input, translated into Pig Latin! -->"
translate_full_input(input)
