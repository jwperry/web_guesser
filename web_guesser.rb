require 'sinatra'
require 'sinatra/reloader'


set :secret_number, rand(100)
attempts = 5
reset_message = ""

get '/' do
  guess = params["guess"].to_i
  message = check_guess(guess)
  back_color = get_background(message)
  cheat_message = cheat?(params["cheat"])
  attempts, reset_message = reset(attempts, guess)
  erb :index, :locals => {:message => message,
                          :reset_message => reset_message,
                          :cheat_message => cheat_message,
                          :guess => guess,
                          :back_color => back_color
                         }
end

def check_guess(guess, number=settings.secret_number)
  return "The secret number is #{settings.secret_number}!" if guess == number
  return "Way too high!" if guess > (number + 5)
  return "Way too low!" if guess < (number - 5)
  return "Too high!" if guess > number
  return "Too low!" if guess < number
end

def get_background(message)
  return "Lime" if message == "The secret number is #{settings.secret_number}!"
  return "DarkRed" if message == "Way too high!"
  return "RoyalBlue" if message == "Way too low!"
  return "LightCoral" if message == "Too high!"
  return "LightSkyBlue" if message == "Too low!"
end

def reset(remaining_guesses, guess)
  if guess == settings.secret_number
    settings.secret_number = rand(100)
    return 5, "\nCongratulations! Creating new number."
  elsif remaining_guesses <= 1
    settings.secret_number = rand(100)
    return 5, "\nYou're out of guesses! Creating new number."
  else
    return (remaining_guesses - 1), "\nYou have #{(remaining_guesses-1)} attempts remaining."
  end
end

def cheat?(cheat)
  if cheat == "true"
    return "\nI hope you're proud of yourself. The secret number is #{settings.secret_number}...you cheating dog."
  else
    return ""
  end
end