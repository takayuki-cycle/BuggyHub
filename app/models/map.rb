class Map < ApplicationRecord
  validates :storage, {inclusion: {in:[true, false]}}
  validates :area, {presence: true}
  validates :lat, {presence: true, inclusion: {in: -90..90}}
  validates :lng, {presence: true, inclusion: {in: -180..180}}
  validates :service_start, {presence: true}
  validates :service_end, {presence: true}
  validates :ride, {presence: true, inclusion: {in: 1..9}}
  validates :name, {presence: true}
end