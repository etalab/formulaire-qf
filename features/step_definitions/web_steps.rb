Quand("je me rends sur la page d'accueil") do
  visit "/"
end

Alors("la page contient {string}") do |content|
  expect(page).to have_content(content)
end

Quand(/je clique sur (le (?:dernier|premier) )?"([^"]+)"\s*$/) do |position, label|
  case position
  when "le dernier "
    page.all("a", text: label).last.click
  when "le premier "
    page.all("a", text: label).first.click
  else
    if javascript?
      find(:link_or_button, label).trigger("click")
    else
      click_link_or_button label
    end
  end
end
