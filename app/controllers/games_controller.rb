require 'open-uri'
require 'json'

class GamesController < ApplicationController
  ALPHABET = ('A'..'Z').to_a
  # session[:total_score] = 0
  def new
    @letters = Array.new(10) { ALPHABET.sample }

  end

  def score
    # binding.pry
    answer = params[:answer]
    grid = params[:grid]
    @message = ""
    if !included?(answer.upcase, grid)
      @message = "Sorry, but #{answer} is not in #{grid.gsub(/ /, ',')}"
    elsif !english_word?(answer)
      @message = "Sorry, but #{answer} does not seem to be a valid English word"
    else
      @message = "Congratulations! #{answer} is a valid answer!"
      @score = "Your score is #{10 * answer.length}"
      session[:total_score] = 0 if session[:total_score].nil?
      session[:total_score] += answer.length
      @total_score = session[:total_score]
    end
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    user_serialized = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    dictionary_result = JSON.parse(user_serialized)
    return dictionary_result["found"]
  end


end
