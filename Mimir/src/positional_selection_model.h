//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_POSITIONAL_SELECTION_MODEL_H
#define MIMIR_POSITIONAL_SELECTION_MODEL_H


#include "abstract_selection_model.h"


namespace mimir {


    class PositionalSelectionModel : public AbstractSelectionModel {

    public:

        PositionalSelectionModel(const ModelParameters &params)
            : AbstractSelectionModel(params)
        {
        }


        virtual Qvalue predict(const Clonotype& clonotype) const {
            // Using _parameters or anything else, compute Qvalues
        }

    };

}


#endif //MIMIR_POSITIONAL_SELECTION_MODEL_H
