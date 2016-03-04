//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_POSITIONAL_SELECTION_MODEL_H
#define MIMIR_POSITIONAL_SELECTION_MODEL_H


#include "abstract_selection_model.h"


namespace mimir {


    class PositionalSelectionModel : public AbstractSelectionModel {
    public:


        virtual Qvalue predict(const Clonotype& clonotype) const {

        }


        virtual bool read(const string_t &filepath) {

        }


        virtual bool write(const string_t &filepath) const {

        }


    protected:


    };

}


#endif //MIMIR_POSITIONAL_SELECTION_MODEL_H
