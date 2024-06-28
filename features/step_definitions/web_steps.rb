Quand("print the page") do
  log page.body
end

Quand("je me rends sur la page d'accueil") do
  visit "/"
end

Sachantque("j'arrive sur le formulaire depuis le portail de ma commune") do
  visit "/collectivites/21040107100019/me_connecter?external_id=123&redirect_uri=http://real_uri"
end

Soit("l'existence de la commune de Majastres") do
  Collectivity.find_by(siret: "21040107100019") ||
    FactoryBot.create(:collectivity, name: "Majastres", siret: "21040107100019", code_cog: "04107", status: "active")
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

Quand("je sélectionne {string} pour {string}") do |option, name|
  select option, from: name
end

# rubocop:disable Lint/Debugger
Alors("debug") do
  debugger
end
# rubocop:enable Lint/Debugger

Alors("la page contient la référence de ma demande") do
  expect(page).to have_content(Shipment.last.reference)
end
