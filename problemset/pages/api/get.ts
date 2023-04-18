import axios from "axios";
import type { NextApiRequest, NextApiResponse } from "next";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const id = req.query.id || "MDo4LDM0MCw5OTA=";
  console.log({ id });
  return axios.get(`https://www.puzzle-aquarium.com/?e=${id}`).then((r) => {
    const lines = (r.data as string).split("\n");
    const line = lines.find((v) => v.includes("var task"));
    if (!line) return res.json({ id: "INVALID", sums: [], frame: [], size: 0 });
    const x = line.split("var task")[1];
    const a = x.indexOf("'");
    const b = x.indexOf("'", a + 1);
    const task = x.slice(a + 1, b).split(";");
    const sums = task[0].split("_");
    const frame = task[1].split(",");
    return res.json({ id, sums, frame, size: sums.length / 2 });
  });
}
