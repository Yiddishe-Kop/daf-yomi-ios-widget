//
//  Shas.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 29/03/2024.
//

import Foundation

class Shas {
    static let tractates: [String: Int] = [
        "ברכות": 63,
        "שבת": 157,
        "עירובין": 104,
        "פסחים": 121,
        "שקלים": 22,
        "יומא": 87,
        "סוכה": 55,
        "ביצה": 40,
        "ראש השנה": 35,
        "תענית": 31,
        "מגילה": 31,
        "מועד קטן": 28,
        "חגיגה": 27,
        "יבמות": 122,
        "כתובות": 112,
        "נדרים": 91,
        "נזיר": 66,
        "סוטה": 49,
        "גיטין": 90,
        "קידושין": 82,
        "בבא קמא": 118,
        "בבא מציעא": 119,
        "בבא בתרא": 176,
        "סנהדרין": 112,
        "מכות": 24,
        "שבועות": 49,
        "עבודה זרה": 76,
        "הוריות": 13,
        "זבחים": 120,
        "מנחות": 110,
        "חולין": 142,
        "בכורות": 61,
        "ערכין": 34,
        "תמורה": 33,
        "כריתות": 27,
        "מעילה": 26,
        "תמיד": 9,
        "נידה": 73,
    ]
    
    static let sefariaRefs: [String: String] = [
        "ברכות": "Berakhot",
        "שבת": "Shabbat",
        "עירובין": "Eruvin",
        "פסחים": "Pesachim",
        "שקלים": "Shekalim",
        "יומא": "Yoma",
        "סוכה": "Sukkah",
        "ביצה": "Beitzah",
        "ראש השנה": "Rosh_Hashanah",
        "תענית": "Taanit",
        "מגילה": "Megillah",
        "מועד קטן": "Moed_Katan",
        "חגיגה": "Chagigah",
        "יבמות": "Yevamot",
        "כתובות": "Ketubot",
        "נדרים": "Nedarim",
        "נזיר": "Nazir",
        "סוטה": "Sotah",
        "גיטין": "Gittin",
        "קידושין": "Kiddushin",
        "בבא קמא": "Bava_Kamma",
        "בבא מציעא": "Bava_Metzia",
        "בבא בתרא": "Bava_Batra",
        "סנהדרין": "Sanhedrin",
        "מכות": "Makkot",
        "שבועות": "Shavuot",
        "עבודה זרה": "Avodah_Zarah",
        "הוריות": "Horayot",
        "זבחים": "Zevachim",
        "מנחות": "Menachot",
        "חולין": "Chullin",
        "בכורות": "Bikkurim",
        "ערכין": "Arakhin",
        "תמורה": "Temurah",
        "כריתות": "Keritot",
        "מעילה": "Meilah",
        "תמיד": "Tamid",
        "נידה": "Niddah",
    ]
    
    static func arabicToHebrew(num: Int) -> String {
        let hebrewThousands = ["", "א׳", "ב׳", "ג׳", "ד׳", "ה׳", "ו׳", "ז׳", "ח׳", "ט׳"]
        let hebrewHundreds = ["", "ק", "ר", "ש", "ת", "תק", "תר", "תש", "תת", "תתק"]
        let hebrewTens = ["", "י", "כ", "ל", "מ", "נ", "ס", "ע", "פ", "צ"]
        let hebrewUnits = ["", "א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט"]
        
        var sThousands = 0
        var sHundreds = 0
        var sTens = 0
        var sUnits = 0
        
        if num > 999 {
            sThousands = num / 1000
        }
        if num > 99 {
            sHundreds = (num % 1000) / 100
        }
        if num > 9 {
            sTens = (num % 100) / 10
        }
        sUnits = num % 10
        
        var myHebrewNumber = hebrewThousands[sThousands] + hebrewHundreds[sHundreds] + hebrewTens[sTens] + hebrewUnits[sUnits] + "*"
        myHebrewNumber = myHebrewNumber.replacingOccurrences(of: "יו*", with: "טז*")
        myHebrewNumber = myHebrewNumber.replacingOccurrences(of: "יה*", with: "טו*")
        myHebrewNumber = String(myHebrewNumber.dropLast())
        
        return myHebrewNumber
    }
    
    static func hebrewToNumber(hebrewNumber: String) -> Int {
        // remove non alef-beis
        let dafWithoutGershayim = hebrewNumber.replacingOccurrences(of: "[^א-ת]", with: "", options: .regularExpression)
        
        let hebrewToNumeric: [Character: Int] = [
            "א": 1,
           "ב": 2,
           "ג": 3,
           "ד": 4,
           "ה": 5,
           "ו": 6,
           "ז": 7,
           "ח": 8,
           "ט": 9,
           "י": 10,
           "כ": 20,
           "ל": 30,
           "מ": 40,
           "נ": 50,
           "ס": 60,
           "ע": 70,
           "פ": 80,
           "צ": 90,
           "ק": 100,
           "ר": 200,
           "ש": 300,
           "ת": 400
        ]

        var numericValue = 0
        for character in dafWithoutGershayim {
            if let value = hebrewToNumeric[character] {
                numericValue += value
            }
        }
        
        return numericValue
    }

}
