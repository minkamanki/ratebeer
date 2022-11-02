class User < ApplicationRecord
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  validate :password_complexity
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_complexity
    return unless password.present?

    errors.add :password, "must include at least one upper case letter." unless password =~ /[A-Z]/
    errors.add :password, "must include at least one digit." unless password =~ /\d/
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def average_of(ratings)
    ratings.sum(&:score) / ratings.count
  end

  def favorite_style
    return nil if ratings.empty?

    group = ratings.group_by{ |r| r.beer.style }
    avg = group.map do |style, ratings|
      { style:, score: average_of(ratings) }
    end

    avg.max_by{ |r| r[:score] }[:style]
  end

  def favorite_brewery
    return nil if ratings.empty?

    group = ratings.group_by{ |r| r.beer.brewery }
    avg = group.map do |brewery, ratings|
      { brewery:, score: average_of(ratings) }
    end

    avg.max_by{ |r| r[:score] }[:brewery]
  end
end
