import type { ReactNode } from "react";
import { useTranslation } from "react-i18next";

import MainHeader from "@/components/headers/MainHeader";
import { Card, CardContent } from "@/components/ui/card";
import MainLoader from "@/components/loader/MainLoader";
import MainTitle from "@/components/titles/MainTitle";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  children: ReactNode;
  header?: string;
  titleCard?: string;
  className?: string;
  loading?: boolean;
}>;

const MainFormCard = ({
  children,
  header = "",
  titleCard = "",
  className = "",
  loading = false,
}: IProps) => {
  const { t } = useTranslation();
  const descriptionHeader =
    header.trim() === "" ? t("header.descriptions.default") : header.trim();
  return (
    <section>
      <MainLoader loading={loading} />
      <MainHeader description={descriptionHeader} />
      <div className="mx-auto max-w-5xl flex justify-center pt-4">
        <Card className={`p-6 ring-0 border-2 border-gray-100 ${className}`}>
          <CardContent>
            <div className="flex flex-col gap-6">
              <MainTitle title={titleCard} />
              <form
                id={buildComponentId("frm", "Data")}
                className="flex flex-col gap-6"
                autoComplete="off"
                onSubmit={(e) => e.preventDefault()}
              >
                {children}
              </form>
            </div>
          </CardContent>
        </Card>
      </div>
    </section>
  );
};

export default MainFormCard;
