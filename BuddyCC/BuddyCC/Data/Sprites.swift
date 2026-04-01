import Foundation

// MARK: - ASCII Sprite Data
// Direct port of sprites.ts BODIES + HAT_LINES.
// Each species has 3 animation frames, each frame is 5 lines of 12 chars.
// "{E}" is replaced at render time with the companion's eye character.

let spriteData: [Species: [[String]]] = [
    .duck: [
        ["            ", "    __      ", "  <({E} )___  ", "   (  ._>   ", "    `--´    "],
        ["            ", "    __      ", "  <({E} )___  ", "   (  ._>   ", "    `--´~   "],
        ["            ", "    __      ", "  <({E} )___  ", "   (  .__>  ", "    `--´    "],
    ],
    .goose: [
        ["            ", "     ({E}>    ", "     ||     ", "   _(__)_   ", "    ^^^^    "],
        ["            ", "    ({E}>     ", "     ||     ", "   _(__)_   ", "    ^^^^    "],
        ["            ", "     ({E}>>   ", "     ||     ", "   _(__)_   ", "    ^^^^    "],
    ],
    .blob: [
        ["            ", "   .----.   ", "  ( {E}  {E} )  ", "  (      )  ", "   `----´   "],
        ["            ", "  .------.  ", " (  {E}  {E}  ) ", " (        ) ", "  `------´  "],
        ["            ", "    .--.    ", "   ({E}  {E})   ", "   (    )   ", "    `--´    "],
    ],
    .cat: [
        ["            ", "   /\\_/\\    ", "  ( {E}   {E})  ", "  (  ω  )   ", "  (\")_(\")   "],
        ["            ", "   /\\_/\\    ", "  ( {E}   {E})  ", "  (  ω  )   ", "  (\")_(\")~  "],
        ["            ", "   /\\-/\\    ", "  ( {E}   {E})  ", "  (  ω  )   ", "  (\")_(\")   "],
    ],
    .dragon: [
        ["            ", "  /^\\  /^\\  ", " <  {E}  {E}  > ", " (   ~~   ) ", "  `-vvvv-´  "],
        ["            ", "  /^\\  /^\\  ", " <  {E}  {E}  > ", " (        ) ", "  `-vvvv-´  "],
        ["   ~    ~   ", "  /^\\  /^\\  ", " <  {E}  {E}  > ", " (   ~~   ) ", "  `-vvvv-´  "],
    ],
    .octopus: [
        ["            ", "   .----.   ", "  ( {E}  {E} )  ", "  (______)  ", "  /\\/\\/\\/\\  "],
        ["            ", "   .----.   ", "  ( {E}  {E} )  ", "  (______)  ", "  \\/\\/\\/\\/  "],
        ["     o      ", "   .----.   ", "  ( {E}  {E} )  ", "  (______)  ", "  /\\/\\/\\/\\  "],
    ],
    .owl: [
        ["            ", "   /\\  /\\   ", "  (({E})({E}))  ", "  (  ><  )  ", "   `----´   "],
        ["            ", "   /\\  /\\   ", "  (({E})({E}))  ", "  (  ><  )  ", "   .----.   "],
        ["            ", "   /\\  /\\   ", "  (({E})(- ))  ", "  (  ><  )  ", "   `----´   "],
    ],
    .penguin: [
        ["            ", "  .---.     ", "  ({E}>{E})     ", " /(   )\\    ", "  `---´     "],
        ["            ", "  .---.     ", "  ({E}>{E})     ", " |(   )|    ", "  `---´     "],
        ["  .---.     ", "  ({E}>{E})     ", " /(   )\\    ", "  `---´     ", "   ~ ~      "],
    ],
    .turtle: [
        ["            ", "   _,--._   ", "  ( {E}  {E} )  ", " /[______]\\ ", "  ``    ``  "],
        ["            ", "   _,--._   ", "  ( {E}  {E} )  ", " /[______]\\ ", "   ``  ``   "],
        ["            ", "   _,--._   ", "  ( {E}  {E} )  ", " /[======]\\ ", "  ``    ``  "],
    ],
    .snail: [
        ["            ", " {E}    .--.  ", "  \\  ( @ )  ", "   \\_`--´   ", "  ~~~~~~~   "],
        ["            ", "  {E}   .--.  ", "  |  ( @ )  ", "   \\_`--´   ", "  ~~~~~~~   "],
        ["            ", " {E}    .--.  ", "  \\  ( @  ) ", "   \\_`--´   ", "   ~~~~~~   "],
    ],
    .ghost: [
        ["            ", "   .----.   ", "  / {E}  {E} \\  ", "  |      |  ", "  ~`~``~`~  "],
        ["            ", "   .----.   ", "  / {E}  {E} \\  ", "  |      |  ", "  `~`~~`~`  "],
        ["    ~  ~    ", "   .----.   ", "  / {E}  {E} \\  ", "  |      |  ", "  ~~`~~`~~  "],
    ],
    .axolotl: [
        ["            ", "}~(______)~{", "}~({E} .. {E})~{", "  ( .--. )  ", "  (_/  \\_)  "],
        ["            ", "~}(______){~", "~}({E} .. {E}){~", "  ( .--. )  ", "  (_/  \\_)  "],
        ["            ", "}~(______)~{", "}~({E} .. {E})~{", "  (  --  )  ", "  ~_/  \\_~  "],
    ],
    .capybara: [
        ["            ", "  n______n  ", " ( {E}    {E} ) ", " (   oo   ) ", "  `------´  "],
        ["            ", "  n______n  ", " ( {E}    {E} ) ", " (   Oo   ) ", "  `------´  "],
        ["    ~  ~    ", "  u______n  ", " ( {E}    {E} ) ", " (   oo   ) ", "  `------´  "],
    ],
    .cactus: [
        ["            ", " n  ____  n ", " | |{E}  {E}| | ", " |_|    |_| ", "   |    |   "],
        ["            ", "    ____    ", " n |{E}  {E}| n ", " |_|    |_| ", "   |    |   "],
        [" n        n ", " |  ____  | ", " | |{E}  {E}| | ", " |_|    |_| ", "   |    |   "],
    ],
    .robot: [
        ["            ", "   .[||].   ", "  [ {E}  {E} ]  ", "  [ ==== ]  ", "  `------´  "],
        ["            ", "   .[||].   ", "  [ {E}  {E} ]  ", "  [ -==- ]  ", "  `------´  "],
        ["     *      ", "   .[||].   ", "  [ {E}  {E} ]  ", "  [ ==== ]  ", "  `------´  "],
    ],
    .rabbit: [
        ["            ", "   (\\__/)   ", "  ( {E}  {E} )  ", " =(  ..  )= ", "  (\")__(\")  "],
        ["            ", "   (|__/)   ", "  ( {E}  {E} )  ", " =(  ..  )= ", "  (\")__(\")  "],
        ["            ", "   (\\__/)   ", "  ( {E}  {E} )  ", " =( .  . )= ", "  (\")__(\")  "],
    ],
    .mushroom: [
        ["            ", " .-o-OO-o-. ", "(__________)", "   |{E}  {E}|   ", "   |____|   "],
        ["            ", " .-O-oo-O-. ", "(__________)", "   |{E}  {E}|   ", "   |____|   "],
        ["   . o  .   ", " .-o-OO-o-. ", "(__________)", "   |{E}  {E}|   ", "   |____|   "],
    ],
    .chonk: [
        ["            ", "  /\\    /\\  ", " ( {E}    {E} ) ", " (   ..   ) ", "  `------´  "],
        ["            ", "  /\\    /|  ", " ( {E}    {E} ) ", " (   ..   ) ", "  `------´  "],
        ["            ", "  /\\    /\\  ", " ( {E}    {E} ) ", " (   ..   ) ", "  `------´~ "],
    ],
]

let hatLines: [Hat: String] = [
    .none:      "",
    .crown:     "   \\^^^/    ",
    .tophat:    "   [___]    ",
    .propeller: "    -+-     ",
    .halo:      "   (   )    ",
    .wizard:    "    /^\\     ",
    .beanie:    "   (___)    ",
    .tinyduck:  "    ,>      ",
]

// MARK: - Render

/// Returns the lines to display for the given frame.
/// Mirrors renderSprite() from sprites.ts exactly.
func renderSprite(bones: CompanionBones, frame: Int) -> [String] {
    guard let frames = spriteData[bones.species] else { return [] }
    let safeFrame = frame % frames.count
    var lines = frames[safeFrame].map { $0.replacingOccurrences(of: "{E}", with: bones.eye.character) }

    // Apply hat to line 0 if it's blank
    if bones.hat != .none, let hatLine = hatLines[bones.hat], lines[0].trimmingCharacters(in: .whitespaces).isEmpty {
        lines[0] = hatLine
    }

    // Drop blank hat slot if ALL frames have blank line 0
    let allFramesHaveBlankTop = frames.allSatisfy { $0[0].trimmingCharacters(in: .whitespaces).isEmpty }
    if lines[0].trimmingCharacters(in: .whitespaces).isEmpty && allFramesHaveBlankTop {
        lines.removeFirst()
    }

    return lines
}

func spriteFrameCount(species: Species) -> Int {
    spriteData[species]?.count ?? 1
}

/// Short face string shown in cards and notifications.
func renderFace(bones: CompanionBones) -> String {
    let e = bones.eye.character
    switch bones.species {
    case .duck, .goose:   return "(\(e)>"
    case .blob:            return "(\(e)\(e))"
    case .cat:             return "=\(e)ω\(e)="
    case .dragon:          return "<\(e)~\(e)>"
    case .octopus:         return "~(\(e)\(e))~"
    case .owl:             return "(\(e))(\(e))"
    case .penguin:         return "(\(e)>)"
    case .turtle:          return "[\(e)_\(e)]"
    case .snail:           return "\(e)(@)"
    case .ghost:           return "/\(e)\(e)\\"
    case .axolotl:         return "}\(e).\(e){"
    case .capybara:        return "(\(e)oo\(e))"
    case .cactus:          return "|\(e)  \(e)|"
    case .robot:           return "[\(e)\(e)]"
    case .rabbit:          return "(\(e)..\(e))"
    case .mushroom:        return "|\(e)  \(e)|"
    case .chonk:           return "(\(e).\(e))"
    }
}
