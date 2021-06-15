//
//  parseEvent.ts
//  livedocs
//
//  Created by d-exclaimation on 09:12.
//
import { DeltaStatic } from "react-quill/node_modules/@types/quill";
import {
  OperationMessage,
  SaveMessage,
  SocketEvent,
} from "./../../models/Event";

export const parseEvent = (ev: MessageEvent<string>): SocketEvent => {
  return JSON.parse(ev.data);
};

export const parseOperation = (delta: DeltaStatic): string => {
  return JSON.stringify({
    type: "operations",
    data: delta,
  } as OperationMessage);
};

export const parseSave = ({
  value,
  id,
}: {
  value: DeltaStatic;
  id: string;
}): string => {
  return JSON.stringify({
    id,
    data: value,
  } as SaveMessage);
};
