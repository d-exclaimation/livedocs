import { DeltaStatic } from "react-quill/node_modules/@types/quill";

export type SocketEvent =
  | { type: "init"; payload: DeltaStatic }
  | { type: "operations"; payload: DeltaStatic };

export type OperationMessage = { type: "operations"; data: DeltaStatic };
export type SaveMessage = { id: string; data: DeltaStatic };
