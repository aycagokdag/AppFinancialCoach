import Foundation

struct PersonalInfoModel {
    var profilePhotoURL: URL?
    var profileScore: Int
    var network: [Double] // Friend's IDs
    var name: String
    var profession: String
    var email: String
    // Other fields to be added

    init(profilePhotoURL: URL? = nil, profileScore: Int = 0, network: [Double] = [], name: String = "", profession: String = "", email: String) {
        self.profilePhotoURL = profilePhotoURL
        self.profileScore = profileScore
        self.network = network
        self.name = name
        self.profession = profession
        self.email = email
    }
}
