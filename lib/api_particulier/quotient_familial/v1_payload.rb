module ApiParticulier
  module QuotientFamilial
    class V1Payload
      def initialize(payload)
        @payload = payload
      end

      def convert_to_v2_format
        convert_persons_v2_format @payload["allocataires"]
        convert_persons_v2_format @payload["enfants"]

        @payload
      end

      private

      def convert_persons_v2_format(persons)
        persons.map! { |allocataire| convert_person_v2_format(allocataire) } if persons.present?
      end

      def convert_person_v2_format(person)
        person["jourDateDeNaissance"] = person["dateDeNaissance"][0..1]
        person["moisDateDeNaissance"] = person["dateDeNaissance"][2..3]
        person["anneeDateDeNaissance"] = person["dateDeNaissance"][4..7]
        person["nomNaissance"] = person["nomPrenom"]
        person["nomUsuel"] = nil
        person["prenoms"] = nil
        person.delete "nomPrenom"
        person.delete "dateDeNaissance"

        person
      end
    end
  end
end
