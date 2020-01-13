import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()

router.all(middleware: BodyParser())
router.all("/", middleware: StaticFileServer(path: "./assets"))

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

func showStudents() -> String {

    var result : String =  ""

    let result_head : String = "<table style='border:1px solid #000; font-family: arial, sans-serif; border-collapse: collapse;'> <tr> <th>Name</th> <th>Mark</th> </tr>"

    var result_body: String = "" 

    for (name, mark) in students {
      result_body += "<tr> <td>\(name)</td> <td>\(mark)</td> </tr>"
    } 

    result = result_head + result_body + "</table>"

    return result
}

func getStudent(_ name : String) -> String {
  return name
}

var newname = getStudent("mama")

router.all(middleware: BodyParser())

router.get("/") { request, response, next in

    let message = showStudents()
    
    response.send("<div><form action='/result' method='POST'><input type='text' name='name'/><input type='submit' value='OK'/></form></div> <div>\(message)</div>")
    
    next()
}

router.post("/result") { request, response, next in
    // will repond to http://localhost:8080/ryan
    
    if let query = request.body?.asURLEncoded{
      query["name"]
      response.send(query["name"])
      next()
    } else {
      response.send("Votre requête est vide.")
      next()
    }

}


Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
