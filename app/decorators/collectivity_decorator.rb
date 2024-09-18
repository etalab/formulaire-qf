class CollectivityDecorator < SimpleDelegator
  def display_name
    "(#{departement}) #{name}"
  end
end
