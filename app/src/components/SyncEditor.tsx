//
//  SyncEditor.tsx
//  livedocs
//
//  Created by d-exclaimation on 16:13.
//

import React, { useState } from "react";
import ReactQuill from "react-quill";

type Props = {};

const SyncEditor: React.FC<Props> = () => {
  const [value, setValue] = useState("");
  return (
    <div style={{ borderWidth: 10, borderColor: "black" }}>
      <ReactQuill theme="snow" value={value} onChange={setValue} />
    </div>
  );
};

export default SyncEditor;
