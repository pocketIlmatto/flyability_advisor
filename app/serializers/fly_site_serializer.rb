class FlySiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :lat, :lng, :hourstart, :hourend, 
    :speedmin_ideal, :speedmax_ideal, :speedmin_edge, :speedmax_edge, :dir_ideal,
    :dir_edge
end