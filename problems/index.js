import axios from 'axios'
import { mkdirSync, writeFileSync } from 'fs'
import { join } from 'path'

const api = axios.create({ baseURL: 'https://aquarium2.vercel.app/api/' })

const get = (id) => api.get('get', { params: { id } }).then((r) => r.data)

const idLibrary = {
  '6x6': {
    easy: [
      'MDo3LDI2NywxODg=',
      'MDoyLDQyOSw1ODc=',
      'MDo1LDU5Myw1Mjk=',
      'MDo1LDU5Myw1Mjk=',
      'MDoxMSwyNjksNjU3',
      'MDozLDM1OCw2MDU=',
    ],
    normal: [
      'MToxNSw4NjgsNTEx',
      'MToxLDg2Myw4MDc=',
      'MToxMiw2NDEsNjY4',
      'MTo0LDQ4MCw3Mjk=',
      'MTo1LDY1MiwwODU=',
      'MToxLDM2Niw4Mzg=',
    ],
    hard: [
      'MjoxMSwxMTMsMTQ1',
      'Mjo3LDQ0Niw2Mzk=',
      'MjoxLDAwMSw4NDE=',
      'MjoxLDMzNCwyNDQ=',
      'MjoxMCwwNzQsNTYw',
      'MjoxMCwzMzgsOTg5',
    ],
  },
  '10x10': {
    easy: [
      'Mzo2LDIyNiw2MTY=',
      'MzozLDA4MSw2ODY=',
      'Mzo2LDYxMiw1Njc=',
      'Mzo0LDI3Myw5Mzg=',
      'Mzo1LDc4MiwxNTc=',
      'MzozLDE0NCw3MzE=',
    ],
    normal: [
      'NDo3LDE5OSwzMjE=',
      'NDo4LDY5Miw1MTQ=',
      'NDo1LDM1MCw5ODc=',
      'NDoyLDIyMSwyNDg=',
      'NDoxLDk3NCwwNjc=',
      'NDo4LDU4NCw2MDg=',
    ],
    hard: [
      'NTo4LDk3NywxMjQ=',
      'NTo4LDIyNCwxNTQ=',
      'NTo2LDczNiw2NTY=',
      'NTo4LDI5OCw4ODU=',
      'NToyLDg2NSwxMTU=',
      'NToyLDkwMyw3OTk=',
    ],
  },
  '15x15': {
    easy: [
      'NjozLDU2MCw5NzM=',
      'Njo5LDMxOCw3NzY=',
      'Njo3LDYzNCwwODc=',
      'Njo5LDcyNiw1NTM=',
      'Njo2LDc2NywyMjU=',
      'NjozLDU4MSwzNTQ=',
    ],
    normal: [
      'Nzo2LDkyNyw4NzY=',
      'NzozLDYxMCwyNjE=',
      'Nzo5LDQ0MSw5OTc=',
      'NzoxLDkwMCwzNzE=',
      'Nzo3LDI2NCwzMzY=',
      'Nzo3LDMyNywxNTg=',
    ],
    hard: [
      'ODoyLDU2NywyOTY=',
      'ODozLDgyMyw4OTk=',
      'ODozLDk0MCwwMzM=',
      'ODo4LDAxMywxMTA=',
      'ODo2LDIwMCwyMTE=',
      'ODo3LDkwOSw3MzI=',
    ],
  },
}

const DB_DIR = 'problem-db'

mkdirSync(DB_DIR, { recursive: true })

get(idLibrary['6x6'].normal[3]).then(console.log)

function download(title, idList) {
  idList.forEach((id, i) => {
    get(id).then((json) =>
      // console.log(JSON.stringify(json))
      writeFileSync(
        join(DB_DIR, `${title}_v${i + 1}.json`),
        JSON.stringify(json)
      )
    )
  })
}

download('6x6_easy', idLibrary['6x6'].easy)
download('10x10_easy', idLibrary['10x10'].easy)
download('15x15_easy', idLibrary['15x15'].easy)

download('6x6_normal', idLibrary['6x6'].normal)
download('10x10_normal', idLibrary['10x10'].normal)
download('15x15_normal', idLibrary['15x15'].normal)

download('6x6_hard', idLibrary['6x6'].hard)
download('10x10_hard', idLibrary['10x10'].hard)
download('15x15_hard', idLibrary['15x15'].hard)
