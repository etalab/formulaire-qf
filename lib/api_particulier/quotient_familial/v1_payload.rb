module ApiParticulier
  module QuotientFamilial
    class V1Payload
      def initialize(payload)
        @payload = payload
      end

      def convert_to_v2_format
        if @payload["error"].present?
          return convert_error_to_v2_format
        end

        convert_people_v2_format @payload["allocataires"]
        convert_people_v2_format @payload["enfants"]
        convert_quotient_familial_v2_format

        @payload
      end

      private

      def convert_people_v2_format(people)
        return if people.blank?

        people.map! { |allocataire| convert_person_v2_format(allocataire) }
      end

      def convert_person_v2_format(person)
        person["date_naissance"] = "#{person["dateDeNaissance"][4..7]}-#{person["dateDeNaissance"][2..3]}-#{person["dateDeNaissance"][0..1]}"
        person["nom_naissance"] = person["nomPrenom"]
        person["nom_usage"] = nil
        person["prenoms"] = nil

        person.delete "nomPrenom"
        person.delete "dateDeNaissance"

        person
      end

      def convert_quotient_familial_v2_format
        @payload["quotient_familial"] = {
          "fournisseur" => "CNAF",
          "valeur" => @payload["quotientFamilial"],
          "annee" => @payload["annee"],
          "mois" => @payload["mois"],
          "annee_calcul" => nil,
          "mois_calcul" => nil,
        }

        @payload.delete "quotientFamilial"
        @payload.delete "annee"
        @payload.delete "mois"
      end

      def convert_error_to_v2_format
        @payload = {
          "title" => @payload["reason"],
          "detail" => @payload["message"],
          "code" => nil,
        }

        @payload.delete "error"
        @payload.delete "reason"

        @payload
      end
    end
  end
end
