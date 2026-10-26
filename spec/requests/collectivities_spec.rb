describe "Return address from a collectivité portal" do
  let(:shipment) { create(:shipment) }
  let(:collectivity) { shipment.collectivity }

  def confirmation_page_after_portal_entry(redirect_uri)
    get "/collectivites/#{collectivity.siret}/me_connecter", params: {redirect_uri: redirect_uri}
    get "/collectivites/#{collectivity.siret}/confirmation/#{shipment.reference}"
    response.body
  end

  it "keeps the button towards an https portal" do
    expect(confirmation_page_after_portal_entry("https://site.example")).to include('href="https://site.example"', "Retourner sur le site de ma collectivité")
  end

  it "keeps the button towards an http portal" do
    expect(confirmation_page_after_portal_entry("http://site.example")).to include('href="http://site.example"', "Retourner sur le site de ma collectivité")
  end

  it "drops a javascript return address and its button" do
    expect(confirmation_page_after_portal_entry("javascript:alert(1)")).not_to include("javascript:", "Retourner sur le site de ma collectivité")
  end

  it "drops a return address that is not a URL and its button" do
    expect(confirmation_page_after_portal_entry("http://exa mple.com")).not_to include("exa mple", "Retourner sur le site de ma collectivité")
  end
end
