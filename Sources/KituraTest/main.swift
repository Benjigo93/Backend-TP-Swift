import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()

router.all(middleware: BodyParser())
router.all(middleware: [BodyParser(), StaticFileServer(path: "./Assets")])

var students : [String : Double] = [
  "Alex": 12.5, 
  "Tristan": 10,
  "Benjamin": 16,
  "Gerard": 11,
  "Kevin": 13,
  "Nicolas": 14,
  "Dylan": 17,
  "Baptiste": 8,
  "Dimitri": 10,
  "Mehdi": 7,
  "Alexandre": 12,
  "Florian": 11,
  "Ferdinand": 10,
  "Dorothé": 11,
  "Elodie": 13,
  "Jeralt": 10,
  "Mélanie": 17,
  "Correntin": 19,
  "Aristide": 10,
  "William": 16,
  "Adil": 14,
  "Gaëlle": 16,
  "Siham": 15,
  "Ludivine": 10,
  "Tess": 18,
  "Michael": 12,
  "Rachel": 16,
  "Jennifer": 5,
  "Maxime": 6,
  "Xavier": 7,
]
let sortedStudents = students.sorted(by: { $0.value < $1.value })

let headerHTML : String = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><meta http-equiv='X-UA-Compatible' content='ie=edge'><link rel='stylesheet' href='style.css'><title>EEMI TECH</title></head><body>"
let footerHTML : String = "</body></html>"
// FUNCTIONS //

func showStudents() -> String {
    
    var result : String =  "<table> <tr> <th>Name</th> <th>Mark</th> </tr>"
    for (name, mark) in sortedStudents {
      result += "<tr> <td>\(name)</td> <td>\(mark)</td> </tr>"
    } 
    result += "</table>"
    return result
}

func getQueryStudents(_ name : String) -> String {

  var result : String = "<div>"
  let filtered = students.filter { $0.key.contains(name) || $0.key.lowercased().hasPrefix(name) }
  for (student) in filtered {
    result += "<a href='student/\(student.key)'>\(student.key)</a>"
  }
  result += "</div>"
  return result
}

func computeStudentData(_ name : String) -> String {
  let mediane : Double = sortedStudents[sortedStudents.count/2].value
  let moyenne : Double = sortedStudents.reduce(0, { result, marks in return result + marks.value/Double(sortedStudents.count)})
  let stringMoyenne : String = String(format:"%.2f", moyenne)
  let ecartype : Double? = students[name]!/moyenne
  let stringEcartype : String = String(format:"%.2f", ecartype!)
  return "La moyenne de \(name) est \(students[name]!) , la mediane de la classe est \(mediane), la moyenne de la classe est \(stringMoyenne), l'écartype de \(name) est \(stringEcartype) "
}

// ROUTER ENDPOINTS //

router.get("/") { request, response, next in
    response.headers["Content-Type"] = "text/html; charset=utf-8"
    let message = showStudents()
    response.send(headerHTML + "<div><form action='/result' method='POST'><input type='text' name='name'/><input type='submit' value='OK'/></form></div> <div>\(message)</div>" + footerHTML)
    next()
}

router.post("/result") { request, response, next in
    // will repond to http://localhost:8080/ryan
    response.headers["Content-Type"] = "text/html; charset=utf-8"
    if let query = request.body?.asURLEncoded{
      query["name"]
      response.send(headerHTML + getQueryStudents(query["name"]!) + footerHTML)
      next()
    } else {
      response.send(headerHTML + "<div class='message'>Votre requête est vide.</div>" + footerHTML)
      next()
    }
}

router.get("/student/:name") { request, response, next in
    response.headers["Content-Type"] = "text/html; charset=utf-8"
    let name = request.parameters["name"] ?? ""
    let data = computeStudentData(name)
    response.send("\(data)")
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
