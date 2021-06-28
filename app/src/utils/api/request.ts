//
//  request.ts
//  livedocs
//
//  Created by d-exclaimation on 11:17.
//
import { DeltaStatic } from "react-quill/node_modules/@types/quill";
import { parseSave } from "../parser/parseEvent";
import { __URL__ } from "./../../constants/uri";

export const saveRequest = (data: { value: DeltaStatic; id: string }) => {
  fetch(__URL__, {
    method: "PUT",
    credentials: "include",
    body: parseSave(data),
    redirect: "follow",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((resp) => resp.text())
    .then(console.log)
    .catch(console.error);
};

export const createDocument = async (): Promise<{ id: string }> => {
  const resp = await fetch(__URL__, {
    method: "POST",
    credentials: "include",
    redirect: "follow",
    headers: {
      "Content-Type": "application/json",
    },
  });
  return resp.json();
};
