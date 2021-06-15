//
//  DocumentViewModel.tsx
//  livedocs
//
//  Created by d-exclaimation on 11:21.
//

import React, { useEffect, useState } from "react";
import { Redirect } from "react-router-dom";
import { createDocument } from "../utils/api/request";

const DocumentViewModel: React.FC = () => {
  const [id, setId] = useState<string | null>(null);
  useEffect(() => {
    createDocument().then(({ id }) => setId(id));
  }, []);
  if (id) {
    return <Redirect to={`/docs?id=${id}`} />;
  }
  return <div className="App"></div>;
};

export default DocumentViewModel;
