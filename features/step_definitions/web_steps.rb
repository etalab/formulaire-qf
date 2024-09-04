Quand("print the page") do
  log page.body
end

Quand("je me rends sur la page d'accueil") do
  visit "/"
end

Sachantque("j'arrive sur le formulaire depuis le portail de ma collectivité") do
  visit "/collectivites/21040107100019/me_connecter?external_id=123&redirect_uri=http://real_uri"
end

Alors("la page contient {string}") do |content|
  expect(page).to have_content(content)
end

Alors("la page ne contient pas {string}") do |content|
  expect(page).to have_no_content(content)
end

Quand(/je clique sur (le (?:dernier|premier) )?"([^"]+)"\s*$/) do |position, label|
  case position
  when "le dernier "
    page.all("a", text: label).last.click
  when "le premier "
    page.all("a", text: label).first.click
  else
    click_link_or_button label
  end
end

Quand("je remplis {string} avec {string}") do |label, value|
  fill_in label, with: value
end

Quand("je sélectionne {string} pour {string}") do |option, name|
  select option, from: name
end

Alors("l'option {string} existe pour {string}") do |option, name|
  expect(page).to have_select(name, with_options: [option])
end

Alors("l'option {string} n'existe pas pour {string}") do |option, name|
  expect(page).not_to have_select(name, with_options: [option])
end

# rubocop:disable Lint/Debugger
Alors("debug") do
  debugger
end
# rubocop:enable Lint/Debugger

Alors("la page contient la référence de ma demande") do
  expect(page).to have_content(Shipment.last.reference)
end
